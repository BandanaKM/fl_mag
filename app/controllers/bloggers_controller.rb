class BloggersController < ApplicationController
  respond_to :html

  def index
    @bloggers = Blogger.all
  end

  def show
    @blogger = Blogger.find_by(:slug => params[:slug])
    @entries = Entry.where(:author => @blogger.id).page(params[:page]).per_page(10).order('mag_published ASC')
  end


  def create
    blogger = Blogger.create(blogger_params)
    if blogger.feed_url.end_with?('/')
      blogger.update(
        :feed_url => blogger.feed_url[0..-2]
      )
    end

    CreateWorker.perform_async(blogger.id)
    respond_to do |format|
      if blogger.save
        format.html {redirect_to '/users/show', notice: "Success!"}
      else
        format.html {redirect_to'/users/show', notice: blogger.errors.full_messages}
      end
    end
  end

  def destroy
  end

  private

  def blogger_params
    params.require(:blogger).permit(:name, :semester, :id, :feed_url)
  end
end
