# frozen_string_literal: true

require "dry/types"

module DuskAPI
  Types = Dry.Types

  module Types
    FilmType = Hash.schema(
      id: Integer,
      name: String,
      director: String,
      language: String,
      length: Integer,
      year: Integer,
      film_genres: Array.of(Hash.schema(id: Integer, name: String)),
      our_rating: Integer.meta(omittable: true),
      their_rating: Integer.meta(omittable: true),
    )

    SettingsType = Hash.schema(
      streaming_countries: Array.of(Hash.schema(
        country_code: String,
        country_name: String,
      )),
      streaming_providers: Array.of(Hash.schema(
        provider_id: Integer,
        provider_name: String,
        logo_path: String.meta(omittable: true),
      )),
    )
  end
end
