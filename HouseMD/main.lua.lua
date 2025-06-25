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

-- Check List
-- Jokers 5/20
-- Actions 2/10
-- Enhancments 0/2

----------------------------------------------
------------MOD CODE -------------------------

-- Key Holder
SMODS.Atlas{
	key = 'Jokers',
	path = 'BurnDownTheHouse.png',
	px = 71,
	py = 95
}

-- Burn Down the House DONE ✔️
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

-- Fool House DONE ✔️
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

-- Reflecting Pools DONE ✔️
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
	
	rarity = 2,

	cost = 7,

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
			'Resets at the end of blind',
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

	config = {extra = { Xmult = 1, Xmult_gain = 0.5}},

	loc_vars = function(self,info_queue,card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
		return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_gain}}
	end,

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.enhancment and context.other_card.enhancment.key == "m_lucky" and not context.other_card.lucky_trigger and not context.blueprint then
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT, 
				message_card = card
			}
		end
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.Xmult = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
		if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
	end, 	
}

-- Thin Ice NOT DONE
SMODS.Joker{
	key = 'lotto',
	loc_txt = {
		name = 'Thin Ice',
		text = {
			'Whenever a {C:attention}chance based effect{} triggers',
			'{X:mult,C:white}destroy{} this {C:attnetion}Joker{} to create',
			'2 {C:dark_edition}Negative{} hanged man cards'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 2,

	cost = 6,

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
			'Retrigger first played {C:attention}lucky{} card',
			'until it triggers twice.'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = true,

	unlocked = true,  

    discovered = true,
	
	rarity = 2,

	cost = 6,

	pos = {x = 3, y = 1},

	config = { extra = { repetitions = 1 } },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.other_card.lucky_trigger then 
			if context.other_card:is_lucky() then
				return {
					message = 'Again...',
					repetitions = card.ability.extra.repetitions,
					card = other.other_card
				}
			end
		end
	end
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

	calculate = function(self, context, card)
        if context.drawing_cards and not context.blueprint then
   	        return {
    	        cards_to_draw = 3
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
			'Has the {C:chips}Chips{} and {C:mult}Mult{}',
			'of last discarded hand'
			
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 2,

	cost = 6,

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
			'sitch them together',
			'{C:inactive}(Has the rank and suit of the right card,',
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
			'for each planet destroyed'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 2,

	cost = 6,

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

--[[

Sudo code for plantary collapse

local var = # of planets held

if "context needed" then
	local text, _ = "hand discarded"
	for i = var do 
		level_up_hand = text
	end
	destroy all planets
	return {level_up = true} 
end

]]--


-- Rossetta Stone NOT DONE
SMODS.Joker{
	key = 'Rossetta',
	loc_txt = {
		name = 'Rossetta Stone',
		text = {
			'2 times per blind',
			'create a random {C:attention}action{} card',
			'when using an {C:attention}action{} card'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = true,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 2,

	cost = 7,

	pos = {x = 0, y = 3},

	calculate = function(self, card, context)
		if context.using_consumeable and context.consumable.ability.set == 'Actions' then
            SMODS.add_card {
            set = 'Actions',
            }
		end
	end	
}

-- The Man Who Sold the World DONE ✔️
SMODS.Joker{
	key = 'bigboss',
	loc_txt = {
		name = 'The Man Who Sold the World',
		text = {
			'When sold',
			'create 2 random',
			'{C:attention}action{} cards',
			'{C:inactive}(Must have room){}'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 1,

	cost = 5,

	pos = {x = 1, y = 3},

	config = {extra = {Actions = 2}},
	loc_vars = function(self, info_queue, card)
        return {vars = { card.ability.extra.Actions}}
    end,
	calculate = function(self, card, context)
		if context.selling_self then
			for i = 1, math.min(card.ability.extra.Actions, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Actions' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        	end
        delay(0.6)
		end
	end
}

-- Combo Plush NOT DONE
SMODS.Joker{
	key = 'v1',
	loc_txt = {
		name = 'Combo Plush',
		text = {
			'Retrigger every {C:attention}action{} card',
			'for each {C:attention}action{} used this blind'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = false,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 3,

	cost = 10,

	pos = {x = 2, y = 3},
}

-- Bustling Fungus NOT DONE
SMODS.Joker{
	key = 'bungus',
	loc_txt = {
		name = 'Bustling Fungus ',
		text = {
			'Gain {C:money}$1{} for each blind beat',
			'without using an {C:attention}action{}'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = true,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 2,

	cost = 7,

	pos = {x = 3, y = 3},
}

-- Time in a bottle DONE ✔️
SMODS.Joker{
	key = 'bottle',
	loc_txt = {
		name = 'Time in a Bottle',
		text = {
			'All {C:attention}Actions{}',
			'are {C:dark_edition}Negative{}'
		}
	},
	atlas = 'Jokers',

	blueprint_compat = true,
	
	unlocked = true,  

    discovered = true,
	
	rarity = 2,

	cost = 7,

	pos = {x = 4, y = 3},

	calculate = function(self, card, context)
		for k, v in pairs(G.consumeables.cards) do
    		if v.ability.set == "Actions" then
        		v:set_edition("e_negative")
    		end
		end
	end
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

-- Action Consumables
SMODS.ConsumableType{
	key = 'Actions',
	primary_colour = G.C.ORANGE,
	secondary_colour = G.C.DARK_EDITION,
	collection_rows = {5, 5},
	loc_txt = {
		collection = 'Action Cards',
		name = 'Action',
		undiscovered = {
			name = 'Hidden Action',
			text = {'This sin has not', 'revealed itself'}
		}
	},
	shop_rate = 100,
}

-- Action Undiscovered Sprite
SMODS.UndiscoveredSprite{
	key = 'Actions',
	atlas = 'Jokers',
	pos  = {x = 8, y = 0}
}

-- Gluttony NOT DONE
SMODS.Consumable{
	key = 'Gluttony',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 7, y = 3},
	loc_txt = {
		name = 'Gluttony',
		text = {
			'Destroy a Joker to gain',
			'XMult equal to its',
			'sell value',
			'{C:attention}For the rest of the Blind{}'
		}
	},

	unlocked = true,  

    discovered = true
}

-- Balance NOT DONE
SMODS.Consumable{
	key = 'Balance',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 5, y = 2},
	loc_txt = {
		name = 'Balance',
		text = {
			'Balance Chips and Mult',
			'{C:attention}For the rest of the Blind{}'
		}
	},

	unlocked = true,  

    discovered = true
}

-- Pride NOT DONE
SMODS.Consumable{
	key = 'Pride',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 6, y = 0},
	loc_txt = {
		name = 'Pride',
		text = {
			'Gain {C:chips}+200{} chips',
			'and {C:mult}+20{} mult',
			'{C:attention}For the rest of the Blind{}'
		}
	},

	unlocked = true,  

    discovered = true
}

-- Greed NOT DONE
SMODS.Consumable{
	key = 'Greed',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 6, y = 2},
	loc_txt = {
		name = 'Greed',
		text = {
			'Add {C:money}$5{} to sell value',
			'to all {C:attention}Jokers{}',
			'{C:attention}For the rest of the Blind{}'
		}
	},

	unlocked = true,  

    discovered = true,

	config = {extra = {Xmult = 2}},

	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.Xmult}}
	end,
}

-- Sloth NOT DONE
SMODS.Consumable{
	key = 'Sloth',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 6, y = 1},
	loc_txt = {
		name = 'Sloth',
		text = {
			'Gain X2 Mult when held',
			'{C:inactive}(Cannot be used){}'
		}
	},

	unlocked = true,  

    discovered = true
}

-- Sin DONE ✔️
SMODS.Consumable{
	key = 'Sin',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 6, y = 3},
	loc_txt = {
		name = 'Sin',
		text = {
			'Create up to 2', 
			'random {C:attention}action{} cards',
			'{C:inactive}(Must have room){}'
		}
	},

	unlocked = true,  

    discovered = true,

	config = { extra = { Actions = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Actions } }
    end,
	use = function(self, card, area, copier)
		for i = 1, math.min(card.ability.extra.Actions, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Actions' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}

-- Envy NOT DONE
SMODS.Consumable{
	key = 'Envy',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 7, y = 0},
	loc_txt = {
		name = 'Envy',
		text = {
			'{C:chips}+1{} hand and {C:mult}+1{} discard',
			'{C:attention}For the rest of the Blind{}'
		}
	},

	unlocked = true,  

    discovered = true,

	config = { extra = { d_size = 4, hands = 1 } },

	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.d_size, card.ability.extra.hands } }
    end,

	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				ease_hands_played(card.ability.extra.hands)
    	    	ease_discard(card.ability.extra)
        		return true 
			end 
		}))
	end,	
	can_use = function(self, card)
        return G.GAME.blind.in_blind
    end,
}

-- Lust NOT DONE
SMODS.Consumable{
	key = 'Lust',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 7, y = 1},
	loc_txt = {
		name = 'Lust',
		text = {
			'{C:attention}+2{} hand size',
			'{C:attention}For the rest of the Blind{}'
		}
	},

	unlocked = true,  

    discovered = true
}

-- Wrath NOT DONE
SMODS.Consumable{
	key = 'Wrath',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 7, y = 2},
	loc_txt = {
		name = 'Wrath',
		text = {
			'{C:mult}1/2{} Blind Size',
			'{C:attention}For the rest of the Blind{}'
		}
	},

	unlocked = true,  

    discovered = true
}

-- Power ALMOST DONE
SMODS.Consumable{
	key = 'Power',
	set = 'Actions',
	atlas = 'Jokers',
	pos = { x = 5, y = 3},
	loc_txt = {
		name = 'Power',
		text = {
			'Create a random', 
			'rare {C:attention}Joker{}', 
			'Triple the score requirement',
			'{C:inactive}(Must have room){}',
			'{C:inactive}(Can only be used during the Blind){}'
		}
	},
	config = { ante_scaling = 2 },

	unlocked = true,  

    discovered = true,

	use = function(self, card, area, copier)
		 G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                SMODS.add_card({ set = 'Joker', rarity = 'Rare' })
                card:juice_up(0.3, 0.5)
				G.GAME.starting_params.ante_scaling = self.config.ante_scaling
                return true
            end
        }))
	end,
	can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit and G.GAME.blind.in_blind
    end,
}
----------------------------------------------
------------MOD CODE END----------------------