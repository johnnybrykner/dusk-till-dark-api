# frozen_string_literal: true

require "dry/types"

module DuskAPI
  Types = Dry.Types

  module Types
    FilmToWatch = Hash.schema(
      id: Integer,
      name: String,
      director: String,
      length: Integer,
      year: Integer,
      film_genres: Array.of(Hash.schema(id: Integer, name: String)),
    )

    FilmPreviouslyWatched = Hash.schema(
      id: Integer,
      name: String,
      director: String,
      length: Integer,
      year: Integer,
      our_rating: Integer,
    )
  end
end
