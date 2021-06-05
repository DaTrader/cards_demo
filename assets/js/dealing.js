/**
 * Engage Browse LiveView JS Interoperability
 */

import {
  newListill,
  prepForSorting,
  completeListill,
  applyCall,
  initApplyCall,
  deinitApplyCall,
} from "./listiller";

const CARD_PREFIX = 'dln-card-';
const VACATION_PREFIX = 'dln-vacation-';
const GAME_PREFIX = "dln-game-";
const FOOD_PREFIX = "dln-food-";


/*************
 * Deck Hooks
 */

export const DeckHeadHook = {
  mounted: function() {
    console.log( `DeckHeadHook mounted for: ${ this.el.id}`);
    // initHookState( this,
    //   {
    //     listill: newListill( 'sort', 'div[data-delete]')
    //   });
    // initApplyCall( this);
  }
};

export const DeckTailHook = {
  mounted: function() {
    console.log( `DeckTailHook mounted for: ${ this.el.id}`);
    // applyCallToDeck( data => setDeck( this, data));
    // completeDeckListill( this);
  },
  // updated: function() {
  //   completeDeckListill( this);
  // },
  // destroyed: function() {
  //   deinitApplyCall( _deck( this));
  // }
};

function completeDeckListill( me) {
  completeListill( _listill( _deck( me)), _deck( me).el);
}


/***********
 * Card Hook
 */

export const CardHook = {
  mounted: function() {
    console.log( `CardHook mounted for: ${ this.el.id}`);
    // applyCallToDeck( data => setDeck( this, data));
    // prepCardForSorting( this);
  },
  // updated: function() {
  //   prepCardForSorting( this);
  // }
};

function prepCardForSorting( me) {
  return prepForSorting( _listill( _deck( me)), me.el, cardId);
}


/***********
 * Entry Hook
 */

export const EntryHook = {
  mounted: function() {
    console.log( `EntryHook mounted for: ${ this.el.id}`);
    // applyCallToDeck( data => setDeck( this, data));
    // prepEntryForSorting( this);
  },
  // updated: function() {
  //   prepEntryForSorting( this);
  // }
};

function prepEntryForSorting( me) {
  return prepForSorting( _listill( _deck( me)), me.el, entryIdProvider( me.el.id));
}


/*******************
 * Sort support functions
 */

function cardId( elemId) {
  return elemId ? ( CARD_PREFIX + elemId) : null;
}

function entryIdProvider( id) {
  if( id.startsWith( VACATION_PREFIX)) return elemId => entryId( VACATION_PREFIX, elemId);
  if( id.startsWith( GAME_PREFIX)) return elemId => entryId( GAME_PREFIX, elemId);
  if( id.startsWith( FOOD_PREFIX)) return elemId => entryId( FOOD_PREFIX, elemId);
  return null;
}

function entryId( prefix, elemId) {
  return elemId ? ( prefix + elemId) : null;
}

/* Calls a function by dispatching it to the Deck element which calls it by providing it with its dataset
 * as the first argument.
 */
function applyCallToDeck( fun) {
  applyCall( 'dln-deck', fun);
}


/**************************************************
 * Centralized Deck Hook state getters and setters
 */

function initHookState( me, state) {
  me._vars = state;
}

function _deck( me) {
  return me._deckObj;
}

function setDeck( me, deckObj) {
  me._deckObj = deckObj;
}

function _listill( me) {
  return me._vars.listill;
}