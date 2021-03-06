class SongsController < ApplicationController

  # GET /songs
  def index
    @current_page_title = 'Songs'
    @songs = Song.order('remote_id desc').all

    respond_to do |format|
      format.html # index.html.erb
      format.xml do
        podcast = Podcast.new(@songs) do |channel|
          channel.title = 'NiftyFinety.com: All 50/90 Demos'
          channel.description = 'A podcast of all downloadable 50/90 demos, updated hourly.'
          channel.link = 'http://niftyfinety.com'

          # Author info for iTunes.  Otherwise, newest song's author is displayed.
          channel.itunes_author = 'NiftyFinety'
          channel.itunes_owner = RSS::ITunesChannelModel::ITunesOwner.new
          channel.itunes_owner.itunes_name = 'NiftyFinety'

          # Album art for iTunes
          channel.image = RSS::Rss::Channel::Image.new
          channel.image.url = URI.join(
            'http://niftyfinety.com',
            ActionController::Base.helpers.asset_url('podcast_logo.png')
          )
          channel.image.title = channel.title
          channel.image.link = channel.link
        end

        render :xml => podcast.to_rss
      end
    end
  end

end
