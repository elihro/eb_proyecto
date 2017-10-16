namespace :sincronizar do
	desc "Sincroniza inmuebles con XML externo"
	task xml: :environment do
		puts "Ejecutando sincronización.."
		diccionario = cargar_diccionario('easybroker')
		f_xml = cargar_xml(diccionario)
		procesar_xml(diccionario, f_xml)
		puts "¡Sincronización finalizada existosamente!"
	end

	private

	def cargar_diccionario (d)
		diccionarios = {
			'easybroker' => {
				:agency => 'agency',
				:bathrooms => 'bathrooms',
				:city => 'city',
				:city_area => 'city_area',
				:content => 'content',
				:date => 'date',
				:floor_area => 'floor_area',
				:floor_number => 'floor_number',
				:fuente => 'https://www.stagingeb.com/feeds/d420256874ddb9b6ee5502b9d54e773d8316a695/trovit_MX.xml.gz',
				:id_extern => 'id',
				:latitute => 'latitute',
				:longitude => 'longitude',
				:parking => 'parking',
				:picture => 'picture',
				:picture_url => 'picture_url',
				:pictures => 'pictures',
				:plot_area => 'plot_area',
				:postcode => 'postcode',
				:price => 'price',
				:property => 'ad',
				:property_type => 'property_type',
				:region => 'region',
				:rooms => 'rooms',
				:time => 'time',
				:title => 'title',
				:type => 'type',
				:unit_floor_area => 'unit_floor_area',
				:unit_plot_area => 'unit_plot_area',
				:url => 'url'
			}
		}

		return diccionarios[d]
	end

	def cargar_xml(diccionario)
		require 'open-uri'
		require 'open_uri_redirections'
		puts "Cargando xml.."
		file = open(diccionario[:fuente], ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
		gz = Zlib::GzipReader.open(file)
		doc = Nokogiri::XML(gz.read)
		puts "  ¡Archivo xml cargado exitosamente!"
		return doc
	end

	def procesar_xml (diccionario, f_xml)
		def actualizar_propiedad(propiedad_xml, diccionario)
			def actualizar_registro_imagenes(prop, propiedad_xml, diccionario)
				def agregar_imagenes_nuevas (prop, propiedad_xml, diccionario)
					urls = propiedad_xml.css('picture_url')
					urls.each do |u|
						Imagen.create(
							available: true,
							propiedad_id: prop.id,
							url: u.text
						) unless Imagen.exists?(propiedad_id:prop.id, url: u.text)
					end
				end

				def desactivar_imagenes_inactivas(prop, propiedad_xml, diccionario)
					Imagen.where(propiedad_id: prop.id).each do |i|
						url = i.url
						query = "#{diccionario[:picture_url]}:contains(url)"
						i.toggle!(:available) unless propiedad_xml.at(query)
					end
				end

				agregar_imagenes_nuevas(prop, propiedad_xml, diccionario)
				desactivar_imagenes_inactivas(prop, propiedad_xml, diccionario)
			end

			def actualizar_registro_propiedad(prop, propiedad_xml, diccionario)
				prop.update(ad_type: propiedad_xml.css(diccionario[:type]).text) unless prop.ad_type == propiedad_xml.css(diccionario[:type]).text
				prop.update(agency: propiedad_xml.css(diccionario[:agency]).text) unless prop.agency == propiedad_xml.css(diccionario[:agency]).text
				prop.update(bathrooms: propiedad_xml.css(diccionario[:bathrooms]).text) unless prop.bathrooms == propiedad_xml.css(diccionario[:bathrooms]).text
				prop.update(city: propiedad_xml.css(diccionario[:city]).text) unless prop.city == propiedad_xml.css(diccionario[:city]).text
				prop.update(city_area: propiedad_xml.css(diccionario[:city_area]).text) unless prop.city_area == propiedad_xml.css(diccionario[:city_area]).text
				prop.update(content: propiedad_xml.css(diccionario[:content]).text) unless prop.content == propiedad_xml.css(diccionario[:content]).text
				prop.update(date: propiedad_xml.css(diccionario[:date]).text) unless prop.date == propiedad_xml.css(diccionario[:date]).text
				prop.update(floor_area: propiedad_xml.css(diccionario[:floor_area]).text) unless prop.floor_area == propiedad_xml.css(diccionario[:floor_area]).text
				prop.update(floor_number: propiedad_xml.css(diccionario[:floor_number]).text) unless prop.floor_number == propiedad_xml.css(diccionario[:floor_number]).text
				prop.update(latitute: propiedad_xml.css(diccionario[:latitute]).text) unless prop.latitute == propiedad_xml.css(diccionario[:latitute]).text
				prop.update(longitude: propiedad_xml.css(diccionario[:longitude]).text) unless prop.longitude == propiedad_xml.css(diccionario[:longitude]).text
				prop.update(parking: propiedad_xml.css(diccionario[:parking]).text) unless prop.parking == propiedad_xml.css(diccionario[:parking]).text
				prop.update(postcode: propiedad_xml.css(diccionario[:postcode]).text) unless prop.postcode == propiedad_xml.css(diccionario[:postcode]).text
				prop.update(plot_area: propiedad_xml.css(diccionario[:plot_area]).text) unless prop.plot_area == propiedad_xml.css(diccionario[:plot_area]).text
				prop.update(price: propiedad_xml.css(diccionario[:price]).text) unless prop.price == propiedad_xml.css(diccionario[:price]).text
				prop.update(property_type: propiedad_xml.css(diccionario[:property_type]).text) unless prop.property_type == propiedad_xml.css(diccionario[:property_type]).text
				prop.update(region: propiedad_xml.css(diccionario[:region]).text) unless prop.region == propiedad_xml.css(diccionario[:region]).text
				prop.update(rooms: propiedad_xml.css(diccionario[:rooms]).text) unless prop.rooms == propiedad_xml.css(diccionario[:rooms]).text
				prop.update(title: propiedad_xml.css(diccionario[:title]).text) unless prop.title == propiedad_xml.css(diccionario[:title]).text
				prop.update(time: propiedad_xml.css(diccionario[:time]).text) unless prop.time == propiedad_xml.css(diccionario[:time]).text
				prop.update(url: propiedad_xml.css(diccionario[:url]).text) unless prop.url == propiedad_xml.css(diccionario[:agency]).text
				prop.update(currency: propiedad_xml.css(diccionario[:price]).attr('currency')) if prop.price? and prop.currency != propiedad_xml.css(diccionario[:price]).attr('currency').text
				prop.update(unit_floor_area: propiedad_xml.css(diccionario[:floor_area]).attr('unit')) if prop.floor_area? and prop.floor_area != propiedad_xml.css(diccionario[:floor_area]).attr('unit').text
				prop.update(unit_plot_area: propiedad_xml.css(diccionario[:plot_area]).attr('unit')) if prop.plot_area? and prop.plot_area != propiedad_xml.css(diccionario[:plot_area]).attr('unit').text
			end
			prop = Propiedad.find_by(id_extern: propiedad_xml.css(diccionario[:id_extern]).text)
			actualizar_registro_propiedad(prop, propiedad_xml, diccionario)
			actualizar_registro_imagenes(prop, propiedad_xml, diccionario)
		end

		def agregar_propiedad(propiedad_xml, diccionario)
			def agregar_registro_imagenes(propiedad_xml, diccionario)
				prop = Propiedad.last
				urls = propiedad_xml.css(diccionario[:picture_url])
				urls.each do |u|
					Imagen.create(
						available: true,
						propiedad_id: prop.id,
						url: u.text
					)
				end
			end

			def agregar_registro_propiedad(propiedad_xml, diccionario)
				prop = Propiedad.create(
					ad_type: propiedad_xml.css(diccionario[:type]).text,
					agency: propiedad_xml.css(diccionario[:agency]).text,
					available: true,
					bathrooms: propiedad_xml.css(diccionario[:bathrooms]).text,
					city: propiedad_xml.css(diccionario[:city]).text,
					city_area: propiedad_xml.css(diccionario[:city_area]).text,
					content: propiedad_xml.css(diccionario[:content]).text,
					date: propiedad_xml.css(diccionario[:date]).text,
					floor_area: propiedad_xml.css(diccionario[:floor_area]).text,
					floor_number: propiedad_xml.css(diccionario[:floor_number]).text,
					id_extern: propiedad_xml.css(diccionario[:id_extern]).text,
					latitute: propiedad_xml.css(diccionario[:latitute]).text,
					longitude: propiedad_xml.css(diccionario[:longitude]).text,
					parking: propiedad_xml.css(diccionario[:parking]).text,
					postcode: propiedad_xml.css(diccionario[:postcode]).text,
					plot_area: propiedad_xml.css(diccionario[:plot_area]).text,
					price: propiedad_xml.css(diccionario[:price]).text,
					property_type: propiedad_xml.css(diccionario[:property_type]).text,
					region: propiedad_xml.css(diccionario[:region]).text,
					rooms: propiedad_xml.css(diccionario[:rooms]).text,
					title: propiedad_xml.css(diccionario[:title]).text,
					time: propiedad_xml.css(diccionario[:time]).text,
					url: propiedad_xml.css(diccionario[:url]).text,
				)
				prop.update(currency: propiedad_xml.css(diccionario[:price]).attr('currency')) if prop.price?
				prop.update(unit_floor_area: propiedad_xml.css(diccionario[:floor_area]).attr('unit')) if prop.floor_area?
				prop.update(unit_plot_area: propiedad_xml.css(diccionario[:plot_area]).attr('unit')) if prop.plot_area?
			end

			agregar_registro_propiedad(propiedad_xml, diccionario)
			agregar_registro_imagenes(propiedad_xml, diccionario)
		end

		def desactivar_propiedades_inactivas(propiedades_xml, diccionario)
			Propiedad.all.each do |p|
				id_extern = p.id_extern
				query = "#{diccionario[:id_extern]}:contains(id_extern)"
				p.toggle!(:available) unless propiedades_xml.at(query)
			end
		end

		propiedades_xml = f_xml.xpath("//#{diccionario[:property]}")
		puts "Procesando xml.."
		puts "    Se encontraron #{propiedades_xml.count} propiedades"
		propiedades_xml.each do |propiedad_xml|
			if Propiedad.exists?(id_extern: propiedad_xml.css(diccionario[:id_extern]).text)
				actualizar_propiedad(propiedad_xml, diccionario)
			else
				agregar_propiedad(propiedad_xml, diccionario)
			end
		end
		desactivar_propiedades_inactivas(propiedades_xml, diccionario)
		puts "  ¡Procesamiento finalizado exitosamente!"
	end
end
