defmodule CardsDemoWeb.Dealing.DeckLive do
  @moduledoc false
  use CardsDemoWeb, :live_view

  ###############################
  # Mount, render and termination
  #

  @impl true
  def mount( _params, _session, socket) do
    { :ok, initialize( socket), temporary_assigns: [ cards: []]}
  end

  @impl true
  def render( assigns) do
    CardsDemoWeb.Dealing.DeckView.prerender( assigns)
  end



  ####################
  # Presentation logic
  #

  alias CardsDemo.Dealing
  alias CardsDemo.Dealing.{ Deck, Card}
  alias CardsDemoWeb.DomMap
  alias PhoenixLiveViewExt.Listiller
  import EMap, only: [ entity: 2]


  # Initializes the LiveView state
  @spec initialize( Socket.t()) :: Socket.t()
  defp initialize( socket) do
    socket
    |> load_deck()
    |> assign_deck_visible?( true)
    |> build_cards( %{})
  end


  # Distills and assigns cards that result inserted, deleted or updated in the socket relative to their old state.
  @spec build_cards( Socket.t(), map()) :: Socket.t()
  defp build_cards( socket, old_assigns) do
    { cards, deck_update} = Listiller.apply( CardsDemoWeb.Dealing.CardComponent, old_assigns, socket.assigns)

    socket
    |> assign_cards( cards)
    |> assign_deck_update( deck_update)
  end


  # Loads and assigns a dealing deck data structure
  @spec load_deck( Socket.t()) :: Socket.t()
  defp load_deck( socket) do
    socket
    |> assign_deck( prototype_deck( socket))
    |> build_dom_map()
  end

  # Builds a dom map of Card entry ids and assigns it to the socket
  # Requires deck be already assigned to the socket.
  @spec build_dom_map( Socket.t()) :: Socket.t()
  defp build_dom_map( socket) do
    deck = lv_deck!( socket)

#    # Concatenate all card keys into a single list - mounts top down
#    entry_keys =
#      for card_id <- deck.cards,
#          card = entity( deck, card_id),
#          reduce: []
#        do
#        entry_keys -> entry_keys ++ card.keys
#      end

    # Put all card keys into a single MapSet - mounts unexpectedly
    entry_keys =
      for card_id <- deck.cards,
          card = entity( deck, card_id),
          reduce: MapSet.new()
        do
        entry_keys -> MapSet.union( entry_keys, MapSet.new( card.keys))
      end

    assign_dom_map( socket, DomMap.map_ids( lv_dom_map( socket) || DomMap.new(), entry_keys))
  end


  # Prototypes a Deck
  @spec prototype_deck( Socket.t()) :: Deck.t()
  defp prototype_deck( socket) do
    Deck.new()
    |> Deck.add_card(
         [ destination: "Bora Bora"]
         |> Card.new()
         |> fetch_card( socket)
       )
    |> elem( 0)
    |> Deck.add_card(
         [ destination: "Aspen"]
         |> Card.new()
         |> fetch_card( socket)
       )
    |> elem( 0)
    |> Deck.add_card(
         [ destination: "Dubrovnik"]
         |> Card.new()
         |> fetch_card( socket)
       )
    |> elem( 0)
    |> Deck.add_card(
         [ genre: "RPG"]
         |> Card.new()
         |> fetch_card( socket)
       )
    |> elem( 0)
  end

  defp fetch_card( card, socket) do
    Dealing.fetch( card, socket_id: socket.id)
  end



  ################################
  # LiveView State getters/setters
  #

  defp lv_deck!( socket) do
    socket.assigns.deck
  end

  defp assign_deck( socket, deck) do
    assign( socket, :deck, deck)
  end

  defp lv_dom_map( socket) do
    socket.assigns[ :dom_map]
  end

  defp assign_dom_map( socket, dom_map) do
    assign( socket, :dom_map, dom_map)
  end

  defp assign_deck_visible?( socket, visible?) do
    assign( socket, :deck_visible?, visible?)
  end

  defp assign_cards( socket, cards) do
    assign( socket, :cards, cards)
  end

  defp assign_deck_update( socket, deck_update) do
    assign( socket, :deck_update, deck_update)
  end
end
