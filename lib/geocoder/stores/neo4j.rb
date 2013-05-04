# -*- coding: utf-8 -*-

require 'geocoder/stores/base'

module Geocoder::Store
  module Neo4j
    include Base

    def to_coordinates
      [:latitude, :longitude].map {|i| send self.class.geocoder_options[i] }
    end

    ##
    # Look up coordinates and assign to +latitude+ and +longitude+ attributes
    # (or other as specified in +geocoded_by+). Returns coordinates (array).
    #
    def geocode
      do_lookup(false) do |o,rs|
        if r = rs.first
          unless r.latitude.nil? or r.longitude.nil?
            o.__send__  "#{self.class.geocoder_options[:latitude]}=",  r.latitude
            o.__send__  "#{self.class.geocoder_options[:longitude]}=", r.longitude
          end
          r.coordinates
        end
      end
    end
 
  end
end
