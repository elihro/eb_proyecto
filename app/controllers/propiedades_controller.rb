class PropiedadesController < ApplicationController
	def index
		@propiedades = Propiedad.all.paginate(:page => params[:page], :per_page => 5)
	end
end
