--- STEAMODDED HEADER
--- MOD_NAME: ForgottenGems
--- MOD_ID: HOUSEMD
--- MOD_AUTHOR: [realmking]
--- MOD_DESCRIPTION: Adds extra Jokers to mechanics I feel need some love. Currently adds 5 Jokers each for Full House, Lucky Cards, and Discard syngergies. 
--- PREFIX: xmpl


-- Helpful libraries of stuff
--[[ 

This is a list of every context.

context.after
context.area
context.before
context.blind
context.blueprint
context.blueprint_card
context.buying_card
context.card
context.card_effects
context.cardarea
context.cards
context.cards_destroyed
context.check_enhancement
context.consumeable
context.cursor_pos
context.debuffed_hand
context.destroy_card
context.destroying_card
context.discard
context.drawing_cards
context.edition
context.end_of_round
context.ending_shop
context.extra_enhancement
context.final_scoring_step
context.first_hand_drawn
context.full_hand
context.game_over
context.glass_shattered
context.hand_space
context.hook
context.ignore_debuff
context.individual
context.interrupt
context.joker_main
context.layer
context.main_eval
context.main_scoring
context.no_blueprint
context.open_booster
context.other_card
context.other_consumeable
context.other_joker
context.other_something
context.playing_card_added
context.playing_card_end_of_round
context.poker_hands
context.post_joker
context.pre_discard
context.remove_playing_cards
context.removed
context.repetition
context.repetition_only
context.reroll_shop
context.retrigger_joker
context.retrigger_joker_check
context.scoring_hand
context.scoring_name
context.selling_card
context.selling_self
context.setting_blind
context.skip_blind
context.skipping_booster
context.stack
context.starting_shop
context.tag
context.type
context.using_consumeable
]]


----------------------------------------------
------------MOD CODE -------------------------

-- Key Holder
SMODS.Atlas{
	key = 'Jokers',
	path = 'BurnDownTheHouse.png',
	px = 71,
	py = 95
}

-- Burn Down the House DONE
SMODS.Joker{
	key = 'BurnDownTheHouse',
	loc_txt = {
		name = 'Burn Down The House',
		text = {
			'Destroy all scored cards if played hand',
			 'is a {C:attention}Full House{}.',
			'Gain {X:mult,C:white}X1{} Mult if played hand' ,
			'contains a {C:attention}Full House{}.',
			'{C:inactive}(Currently {X:mult,C:white} X#1#{C:inactive} Mult)'
		}
	},
	atlas = 'Jokers',
	
	blueprint_compat = true,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 10,

	pos = {x = 0, y = 0},

	config = {extra = { Xmult = 1, Xmult_gain = 1}},

	loc_vars = function(self,info_queue,card)
		return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_gain}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.Xmult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
			}
		end
		if context.before and next(context.poker_hands['Full House']) and not context.blueprint then
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
			return {
				message = 'Upgraded!',
				colour = G.C.XMULT,
				card = card
			}
		end 
		if context.destroying_card and next(context.poker_hands['Full House']) and not next(context.poker_hands['Flush House']) and not context.blueprint then
			return {
				remove = true
			}
		end
	end
}

-- Fool House DONE
SMODS.Joker{
	key = 'FoolHouse',
	loc_txt = {
		name = 'Fool House',
		text = {
			'Create a copy of {C:attention}The Fool{}', 
			'if played hand',
			'contains a {C:attention}Full House{}.'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = true, 

	rarity = 2,

	cost = 6,

	unlocked = true, 

    discovered = true,

	pos = {x = 1, y = 0},

	config = {extra = {}},
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Full House']) then
			G.E_MANAGER:add_event(Event({
				func = function()
					SMODS.add_card{key="c_fool"}
					return true
				end
			}))
		end	
	end
}

-- Lighthouse HALF DONE
SMODS.Joker{
	key = 'LightHouse',
	loc_txt = {
		name = 'Lighthouse',
		text = {
			'If played hand is',
			'{C:attention}Flush House{}',
			'one random hand will',
			'win the blind.',
			'Hand size is 7' 
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false, 

	rarity = 3,

	cost = 12,

	unlocked = true, 

    discovered = true,

	pos = {x = 2, y = 0},

	config = { extra = {poker_hand = 'High Card' } },

    

	calculate = function(self, card, context)
		if context.after and next(context.poker_hands['High Card']) then
			G.E_MANAGER:add_event(Event({
            	blocking = false,
            	func     = function()
                	if G.STATE == G.STATES.SELECTING_HAND then
                    	G.GAME.chips     = G.GAME.blind.chips
                    	G.STATE          = G.STATES.HAND_PLAYED
                    	G.STATE_COMPLETE = true
                    	end_round()
                    	return true
                	end
            	end
        	}))
		end	
	end
}

-- Overflowing Cup NOT DONE
SMODS.Joker{
	key = 'OverflowingCup',
	loc_txt = {
		name = 'Overflowed Cup',
		text = {
			'If played hand contains',
			'a {C:attention}Full House{}',
			'retrigger the triple 3 times',
			'and debuff the pair.'
			
		}
	},
	atlas = 'Jokers',
	
	blueprint_compat = false, 
	
	rarity = 3,

	cost = 12,

	unlocked = true,

	discovered = true,

	pos = {x=3, y= 0},

	config = { extra = { repetitions = 3 } },

	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Full House']) then
		end
	end
}

-- Reflecting Pools DONE
SMODS.Joker{
	key = 'reflectingpools',
	loc_txt = {
		name = 'Pool House',
		text = {
			'If played hand contains',
			'a {C:attention}Full House{}',
			'balanced base chips and mult.'
		}
	},
	atlas = 'Jokers',
	
	blueprint_compat = false, 
	
	rarity = 3,

	cost = 10,

	unlocked = true,

	discovered = true,

	pos = {x=4, y= 0},

	calculate = function(self, card, context)
		if context.modify_hand and next(context.poker_hands['Full House']) then
			return {balance = true}
		end	
	end
}

-- Doubter NOT DONE
SMODS.Joker{
	key = 'NeverHappens',
	loc_txt = {
		name = 'Doubter',
		text = {
			'Gains {X:mult,C:white}X0.25{} Mult',
			'whenever a chance based effect',
			'does not trigger.',
			'{C:inactive}(Currently {X:mult,C:white} X#1#{C:inactive} Mult)'
		}
	},
	atlas = 'Jokers',

	atlas = 'Jokers',
	
	blueprint_compat = true,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 2,

	cost = 7,

	pos = {x = 0, y = 1},

	config = {extra = { Xmult = 1, Xmult_gain = 0.25}}
	
}

-- Thin Ice NOT DONE
SMODS.Joker{
	key = 'lotto',
	loc_txt = {
		name = 'Thin Ice',
		text = {
			'Whenever a chance based effect triggers',
			'destroy this Joker to create',
			'3 negative hanged man cards'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 10,

	pos = {x = 1, y = 1},
}

-- Lucky Number 7 HALF DONE
SMODS.Joker{
	key = 'oldpeople',
	loc_txt = {
		name = 'Lucky Number 7',
		text = {
			'All played {C:attention}Lucky 7s{}',
			'become {C:attention}Super Lucky{} cards',
			'when scored'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 12,

	pos = {x = 2, y = 1},
}

-- Ad Nauseum NOT DONE
SMODS.Joker{
	key = 'cheater',
	loc_txt = {
		name = 'Ad Nauseum',
		text = {
			'Retrigger first played lucky card',
			'until it triggers twice.'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = true,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 14,

	pos = {x = 3, y = 1},
}

-- The Mold HALF DONE
SMODS.Joker{
	key = 'LuckyBox',
	loc_txt = {
		name = 'The Mold',
		text = {
			'All played {C:attention}lucky cards{}',
			'become {C:attention}moldy{} cards',
			'when scored',
			'{C:inactive}(Moldy cards are pershiable,',
			'{C:inactive} spread to other cards when scored', 
			'{C:inactive} and provide {X:mult,C:white} X3 {C:inactive} Mult)'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = true,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 10,

	pos = {x = 4, y = 1},
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:get_id() == 7 and not context.blueprint then
			if SMODS.has_enhancement(card, "lucky") then
				return
			end
		end
	end
}

-- Burning Desires HALF DONE
SMODS.Joker{
	key = 'Burningheart',
	loc_txt = {
		name = 'Burning Desires',
		text = {
			'{X:mult,C:white}+4{} Discards this round.',
			'Always draw 4 cards.'
		}
	},
	atlas = 'Jokers',

	atlas = 'Jokers',
	
	blueprint_compat = true,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 10,

	pos = {x = 0, y = 2},

	config = { extra = { d_size = 4  } },

	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.d_size } }
    end,

	add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
        ease_discard(card.ability.extra.d_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
        ease_discard(-card.ability.extra.d_size)
    end,

	calculate = function(self, context, card, blind)
        if context.drawing_cards  then
            return {
                cards_to_draw = 4
            }   
        end
    end
	
}

--Seer Gift NOT DONE
SMODS.Joker{
	key = 'mindblow',
	loc_txt = {
		name = 'Seer Gift',
		text = {
			'If discarded cards are',
			'(5 random cards)',
			'gain {X:mult,C:white}X5{} Mult'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = true,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 10,

	pos = {x = 1, y = 2},
}

--Tome of the Dead NOT DONE
SMODS.Joker{
	key = 'tome',
	loc_txt = {
		name = 'Tome of the Dead',
		text = {
			'Gets the chips and mult',
			'of discared cards.'
			
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 12,

	pos = {x = 2, y = 2},

	config = { extra = { chips = 0, mult = 0 } },

	calculate = function(self, context, card)
        if context.discard then
			card.ability.extra.mult = card.ability.extra.mult + context.other_card:get_chip_mult()
			card.ability.extra.chips = card.ability.extra.chips + context.other_card:get_chip_bonus()
            return {
            	message = localize('k_upgrade_ex'),
            	colour = G.C.RED  
            }   
        end
    end
}

--Corpse Sticher NOT DONE
SMODS.Joker{
	key = 'sticher',
	loc_txt = {
		name = 'Corpse Sticher',
		text = {
			'If first discard of round',
			'has exactly 2 cards',
			'sitch them their effects together',
			'{C:inactive}(Has the rank and suit of the left card,',
			'{C:inactive} and the combined effects of both cards)'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 14,

	pos = {x = 3, y = 2},

	
}

-- Plantary Collapse NOT DONE
SMODS.Joker{
	key = 'planetss',
	loc_txt = {
		name = 'Planetary Collapse',
		text = {
			'Destroy all planet cards held',
			'to upgrade discared hand',
			'by 2 for each planet destroyed'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 10,

	pos = {x = 4, y = 2},
	calculate = function(self, card, context)
        if context.pre_discard and G.GAME.current_round.discards_used <= 0 and not context.hook then
            local text, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            return {
                level_up = true,
                level_up_hand = text
            }
        end
    end,
}

-- Super Lucky Cards HALF DONE
SMODS.Enhancement {
	key = 'super',
	loc_txt = {
		name = 'Super Lucky',
		text = {
			'1/3 Chance for {X:mult,C:white} X3{} mult',
			'and 1/10 Chance for {C:attention} X2 dollars{}'
		}
	},

	atlas = 'Jokers',

	pos = {x = 5, y=0},
	config = {extra = {Xmult = 1, mult_odds = 3, dollars_odds = 10}},
	loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal, card.ability.extra.Xmult, card.ability.extra.mult_odds, card.ability.extra.dollars_odds } }
    end,
	calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local ret = {}
			if pseudorandom('lucky_mult') < G.GAME.probabilities.normal / card.ability.extra.mult_odds then
                card.lucky_trigger = true
                ret.mult = card.ability.extra.Xmult
            end
			return ret
		end
	end,
}

-- Moldy Cards HALF DONE
SMODS.Enhancement {
	key = 'mold',
	loc_txt = {
		name = 'Moldy',
		text = {
			'Debuffed after 3 turns',
			'{X:mult,C:white} X2{} mult and 100 chips'
		}
	},
	atlas = 'Jokers',
	 config = { Xmult = 2},
	pos = {x = 5, y = 1},
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.Xmult} }
    end,
	
}


----------------------------------------------
------------MOD CODE END----------------------