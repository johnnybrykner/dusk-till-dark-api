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
  end
end
