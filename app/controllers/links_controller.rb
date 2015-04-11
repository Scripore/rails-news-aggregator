class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  before_action :authorized_user, only: [:edit, :update, :destroy]
  # GET /links
  # GET /links.json
  def index

    search_phrase_array = []



      if params['search_phrase'].nil?
         search_phrase_array << "artificial intelligence"
      else
        SavedSearch.create(:title =>  params['search_phrase']['title'])
        if params['search_phrase']['title'].include? ','
          search_phrase_array = params['search_phrase']['title'].split(',')
        else
          search_phrase_array << params['search_phrase']['title']
        end
      end



    Link.destroy_all
    search_phrase_array.each do |search_phrase|
      client = RedditKit::Client.new 'myrailsproject99', 'myrailsproject99!!'

      rr = client.search(search_phrase, {:time => :month, :limit => 20})
      rr.results.sort_by {|el| el.num_comments }.reverse.each do |thread|
        link = Link.new
        link.url = thread.url
        link.title = thread.title
        link.subreddit = thread.subreddit
        link.score = thread.score
        link.permalink = thread.permalink
        link.created = thread.attributes[:created_utc]
        link.num_comments = thread.num_comments


        link.save
      end
    end

    @link = Link.new
    @links = Link.all.sort_by {|el| el.num_comments }.reverse
  

  end



  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = current_user.links.build
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    binding.pry
    @links = Link.all
    render 'links/index'
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def authorized_user
    @link = current_user.links.find_by(id: params[:id])
    redirect_to links_path, notice: "Not authorized to edit this link" if @link.nil?
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def link_params
    params.require(:link).permit(:title, :url)
  end
end

