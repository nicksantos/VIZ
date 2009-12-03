# Don't change this file!
# Configure your app in config/environment.rb and config/environments/*.rb

RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)

module Rails
  class << self
    def boot!
      unless booted?
        preinitialize
        pick_boot.run
      end
    end

    def booted?
      defined? Rails::Initializer
    end

    def pick_boot
      (vendor_rails? ? VendorBoot : GemBoot).new
    end

    def vendor_rails?
      File.exist?("#{RAILS_ROOT}/vendor/rails")
    end

    def preinitialize
      load(preinitializer_path) if File.exist?(preinitializer_path)
    end

    def preinitializer_path
      "#{RAILS_ROOT}/config/preinitializer.rb"
    end
  end

  class Boot
    def run
      load_initializer
      Rails::Initializer.run(:set_load_path)
    end
  end

  class VendorBoot < Boot
    def load_initializer
      require "#{RAILS_ROOT}/vendor/rails/railties/lib/initializer"
      Rails::Initializer.run(:install_gem_spec_stubs)
      Rails::GemDependency.add_frozen_gem_path
    end
  end

  class GemBoot < Boot
    def load_initializer
      self.class.load_rubygems
      load_rails_gem
      require 'initializer'
    end

    def load_rails_gem
      if version = self.class.gem_version
        gem 'rails', version
      else
        gem 'rails'
      end
    rescue Gem::LoadError => load_error
      $stderr.puts %(Missing the Rails #{version} gem. Please `gem install -v=#{version} rails`, update your RAILS_GEM_VERSION setting in config/environment.rb for the Rails version you do have installed, or comment out RAILS_GEM_VERSION to use the latest version installed.)
      exit 1
    end

    class << self
      def rubygems_version
        Gem::RubyGemsVersion rescue nil
      end

      def gem_version
        if defined? RAILS_GEM_VERSION
          RAILS_GEM_VERSION
        elsif ENV.include?('RAILS_GEM_VERSION')
          ENV['RAILS_GEM_VERSION']
        else
          parse_gem_version(read_environment_rb)
        end
      end

      def load_rubygems
        min_version = '1.3.2'
        require 'rubygems'
        unless rubygems_version >= min_version
          $stderr.puts %Q(Rails requires RubyGems >= #{min_version} (you have #{rubygems_version}). Please `gem update --system` and try again.)
          exit 1
        end

      rescue LoadError
        $stderr.puts %Q(Rails requires RubyGems >= #{min_version}. Please install RubyGems and try again: http://rubygems.rubyforge.org)
        exit 1
      end

      def parse_gem_version(text)
        $1 if text =~ /^[^#]*RAILS_GEM_VERSION\s*=\s*["']([!~<>=]*\s*[\d.]+)["']/
      end

      private
        def read_environment_rb
          File.read("#{RAILS_ROOT}/config/environment.rb")
        end
    end
  end
end

# All that for this:
Rails.boot!
class Weather
@time
@title
@longitude
@latitude
@altitude
@magnitude
@heading
attr_accessor:time
attr_accessor:title
attr_accessor:longitude
attr_accessor:latitude
attr_accessor:altitude
attr_accessor:magnitude
attr_accessor:heading
end

weather_points = Array.new(1)
weather_points[0] = Weather.new
weather_points[0].time = 9001
weather_points[0].title = "weather1"
weather_points[0].longitude = 50
weather_points[0].latitude = 50
weather_points[0].altitude = 6000
weather_points[0].magnitude = 25
weather_points[0].heading = 200

require 'rubygems'

require 'builder' 

xml = Builder::XmlMarkup.new(:indent => 2)

xml.instruct! :xml

xml.kml( "kmlns" => "http://www.opengis.net/kml/2.2" , "xmlns:gx" => "http://www.google.com/kml/ext/2.2" ) do
  xml.Document {
    xml.name("weather") #Placeholder
    weather_points.each do |weather_data|
    xml.Placemark {
      xml.title(weather_data.time)
      xml.description {
              xml.cdata!("#{weather_data.title}<br>time = #{weather_data.time}<br>long = #{weather_data.longitude}  &deg;<br>lat = #{weather_data.latitude} &deg;<br>alt = #{weather_data.altitude} feet<br>")
      }
	xml.visibility("1")
	xml.open("1")
	xml.style{
        xml.IconStyle{
          xml.icon{xml.href("http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png")}
          xml.scale("0.5")
        }
        xml.BalloonStyle{
          xml.bgcolor("ffffffff")
          xml.textcolor("ff000000")
          xml.text{xml.cdata!("$[name]<p>[discription]")}
        }
    }
	xml.Model("id"=>"windbarb#{weather_data.magnitude/5*5}"){
		xml.altitudeMode("relativeToGround")
		xml.Location{
			xml.longitude("#{weather_data.longitude}")
			xml.latitude("#{weather_data.latitude}")
			xml.altitude("#{weather_data.altitude}")
		}
		xml.Orientation{
			xml.heading("#{weather_data.heading}")
			xml.tilt("0")
			xml.roll("0")
		}
		xml.Scale{
			xml.x("1");
			xml.y("1");
			xml.z("1");
		}
		xml.Link{
			xml.href("windbarb#{weather_data.magnitude/5*5}.dae")
		}
	}
	  
	  
      #xml.Point{
      #  xml.extrude("1")
      #  xml.altitudeMode("absolute")
      #  xml.coordinates("#{weather.longitude}, #{weather.latitude}, #{weather.altitude}")
      #}
    }
    end
  }
end  

xml