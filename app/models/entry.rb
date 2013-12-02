class Entry < ActiveRecord::Base
  belongs_to :feed
  belongs_to :blogger
  has_many :entries_tags
  has_many :tags, through: :entries_tags

  before_save :slugify!

  def slugify!
    self.title != nil ? self.slug = self.title.downcase.gsub(/[\W,\s]/,'-') : self.slug = self.id
  end

  def self.most_recent
    order("published DESC").limit(1).first
  end
  
  def author_name
    self.feed.blogger.name
  end

  def author_slug
    self.feed.blogger.slug
  end

  def tags_added
    self.entries_tags.collect do |entry_tag|
      Tag.find(entry_tag.tag_id) if entry_tag.visible == true
    end.reject(&:nil?)
  end

  def safe_html(html)
    Sanitize.clean(html, {:remove_contents => true})
  end

  def summarize
    if self.content
      if self.content.include?("<p>")
        first = self.content.split("<p>")[1]
        second = self.content.split("<p>")[2]
        first = safe_html(first)
        second = safe_html(second)
        first = first + "</p>" if first && !first.end_with?("</p>")
        second = second + "</p>" if second && !second.end_with?("</p>")
        first + "<p>" + second if first && second
      else
        "<p>" + self.content + "</p>"
      end
    end
  end

  def tag_filter(keyword)
    skips = ["the", "a", "an", "it", "&", "way", "<", ">", "quo", "p", "code", "project", "=", "[", "]", "\"", " ", "'", "li", "ul", "td", "tr", "da", "href", ":", ",", "h", "o"]
    return true if skips.collect do |skip|
      keyword.downcase.include?(skip)
    end.uniq.include?(true)
  end

# skip.match(/[^a-zA-Z]/).nil?

  def get_tags
    extractor = Phrasie::Extractor.new
    rough_tags = extractor.phrases(self.content, strength: 3, occur: 2)
    rough_tags.each do |tag|
      next if tag_filter(tag[0])
      tag = Tag.find_or_create_by(:word => tag[0].downcase)
      EntriesTag.create(:entry_id => self.id, :tag_id => tag.id) if tag.ignore != nil && tag.ignore != true
    end
    self.get_title_tags if self.title != nil
  end

  def get_title_tags
    rough_tags = self.title.split(" ")
    rough_tags.each do |tag|
      next if tag_filter(tag)
      tag = Tag.find_or_create_by(:word => tag.downcase) 
      EntriesTag.create(:entry_id => self.id, :tag_id => tag.id) if tag.ignore != nil && tag.ignore != true
    end
  end

  def self.sort_by_date_published(collection)
    collection.sort_by{|entry| entry.published}
  end

  def self.featured_entries
    self.where(:added? => true).sort_by{ |entry| entry.mag_published }
  end

  def self.collect_by_tag(tag_id)
    tags = EntriesTag.where(:tag_id => tag_id, :visible => true)
    tags.collect do |tag|
      self.where(:id => tag.entry_id)
    end
  end

end