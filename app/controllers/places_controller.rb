class PlacesController < ApplicationController

	layout "place"
	require 'socket'

	def show

		if current_user
			@user = current_user
		else
			@user = nil
		end

		@place = Place.find(params[:id])
		rate = RatingCache.where('cacheable_id=?', @place.id)
		if(rate != nil)
			@rating = rate.first.qty
		else
			@rating = 0
		end
	end

	def show_json
		latlng = [params[:lat], params[:lng]]
		radius = params[:radius]

		if radius == 0
			radius = 100
		end

		@places = Place.within(radius,  :origin => latlng)
		
		render :json => @places
	end

	def index
		if current_user
			@user = current_user
		else
			@user = nil
		end

		@ratings = RatingCache.all
		@places = Place.all
		@host =  Socket.gethostname
	end

	def within
		latlng = [params[:lat], params[:lng]]
		radius = params[:radius]

		if radius == 0
			radius = 100
		end
		@places = Place.within(radius,  :origin => latlng)

	end

	def getPhotos
		@photos = Photo.where(:place_id => params[:id])
		render :json => @photos
	end

	def create
		@place = Place.create(place_params)
	end


	def destroy
	end

	def update
	end

	private
		def place_params
			params.require(:place).permit(:title, :description, :lat, :lng)
		end
end
