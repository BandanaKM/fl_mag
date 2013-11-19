class BloggersController < ApplicationController


  def create
    blogger = Blogger.create(blogger_params)
    blogger.build_feed(:feed_url => params[:blogger][:xml_address])
    feed = blogger.feed
    feedzirra_object = Feedzirra::Feed.fetch_and_parse(feed.feed_url) 
    feed.add_entries(feedzirra_object.entries)
    blogger.feed.save
  end



  private

  def blogger_params
    params.require(:blogger).permit(:name, :semester)
  end
end