/* --- Copyright University of Birmingham 2010. All rights reserved. ------
 > File:            ?????/robolex.p
 > Purpose:         Defined a lexicon for a toy language used for robot dialogues
 > Author:          Aaron Sloman, Oct 19 2010 (see revisions)
 > Documentation:
 > Related Files:   newgrammar.p, robogram.p test_robolang.p
 */



global vars robolex =

    ;;; The lexicon: an arbitrary sample.
    ;;; Each entry is the lexical type name and a list of instances
    ;;; The same word can be in different lexical entries
    ;;; e.g. 'left' could be verb and a spatial relation word
    ;;; (Some of the things in the grammar and lexicon are experimental and
    ;;; should be removed for serious use, e.g. names of people.)
    ;;;

    [

/*
-- Types of Adjective
*/
        ;;; Some useful kinds of adjectives
        [sizeadj huge big medium small tiny wide narrow thin heavy]
        [colouradj red orange yellow green blue black white]
        [shapeadj square round triangular rectangular]
        [orientadj upright horizontal]
        ;;;

/*
-- Types of size (for how X is Y, what X is Y
*/
        ;;; Some useful kinds of adjectives
        ;;; Versions for how X is Y (could be further subdivided)
        [how_sizeadj big tall wide narrow long thin thick heavy]
        ;;; Versions of what size,
        [what_sizeadj size height width weight length area]
        ;;; (we may need something different for weight)
        ;;;
/*
-- Types of Determiner
*/
        ;;; MISSING:   one all most every each
        [det_sing the this that a some any]
        [det_pl the those some any]
        ;;;
/*
-- Location selector determiner
*/
        ;;; for things like 'this side of' 'that side of' 'this face of'
        [loc_det this that]
        ;;;

/*
-- Types of Preposition
*/
        ;;; Various kinds of preposition, some general some restricted
        [prep      in on at to under over near behind inside from with]

        ;;; Prepositions followed by 'to'
        [next_prep next near close]
        ;;; Prepositions followed by 'from'
        [far_prep far away]

        ;;; primitive spatial relations
        [loc_prep  in on at under near behind by]
        [path_prep alongside past by near towards]
        ;;;
        ;;; places to which something can move or be moved, placed,
        ;;; should 'in' 'on',,, be included?
        [dest_prep to on onto into at under over near behind in]
        [target_prep to towards onto into]
        [contain_prep in inside within]
        [source_prep from]
        [means_prep with]
        [purpose_prep for]
        [relprep between]
        [speed_adv slowly quickly fast rapidly]
        [amount_adv very slightly]
        ;;;
        [means_adv by]
        ;;; these should be subdivided
        [noun_sing ball block box
            car circle cube cup square
            tray thing table triangle
            cow pig horse sheep bicycle
            kitchen study hall bedroom bathroom corridor
            wheel bonnet door]
        [noun_pl balls blocks boxes
            cars circles cubes cups squares
            trays things tables triangles
            cornflakes
            cows pigs horses sheep bicycles
            kitchens studies halls bedrooms bathrooms corridors
            wheels bonnets doors]
        ;;; 'fake' names of things in the world
        [thing_name Box1 Box2 Ball1 Ball2 Tray1 Mug1 Mug2 TheTable]
        [person_name Nick Robbie GJ Jeremy Aaron Henrik Patric Ales Danijel Dexter
            Dora George Sebastian Charles Marek Yasemin Dani Marc Bernhard Michael]

        ;;; pronouns
        [thing_pronoun_sing  it this that]
        [thing_pronoun_pl they those]
        [thing_pronoun_obj_pl them those]
        ;;; personal pronouns
        [person_pronoun_subj he He she She]
        [person_pronoun_subj_i i I]
        [person_pronoun_subj_you you You]
        [person_pronoun_obj him her you]

        ;;; plural
        [person_pronoun_subj_pl they They you You we We]
        [person_pronoun_obj_pl them you]
        ;;; possessive
        [person_pronoun_pos_sing his her your my]
        [person_pronoun_pos_pl their our your]
        ;;;
        ;;; Some hacks for referring to locations/regions in space
        [loc here there inside outside]
        [loc_vert top bottom]
        [loc_hor left right]
        [loc_face front back nearside farside]
        [loc_hor_type side flank]
        ;;; 'the front face of...'
        [loc_face_type face]

        ;;;
        ;;; [query: is which where]
        ;;; what/who/which is/did/does ....
        [what_word what who which]
        ;;; which X, what X, ...
        [which_word what  which]
        ;;;
        ;;; transitive verbs of state, not action
        [do_to_np   touch contain hide occlude]
        [does_to_np touches contains hides occludes]
        ;;; verbs with two objects
        [do_to_np_and_np separate link bridge]
        [does_to_np_and_np separates links bridges]
        ;;; verbs with direct and indirect object, where direct object
        ;;; is compulsory, but indirect object optional.
        [do_putverb   drop leave]
        [do_getverb   grasp grab fetch get take hoist]
        ;;; can be followed by 'from'
        [do_getverb_pp fetch get take hoist]
        ;;; can be followed by 'up'
        [do_pickverb pick lift pull hoist]
        [does_putverb places drops leaves]
        [do_putverb_pp   put drop place leave]
        [does_putverb_pp puts drops places leaves]
        ;;; verbs with direct object and source and destination, where
        ;;; source and destination are both optional and can occur in
        ;;; either order
        [do_pushverb  move  shift  pull  push   shove  throw put]
        [does_pushverb moves shifts pulls pushes shoves throws puts]
        ;;; intransitive move verbs with optional destination and source objects
        [do_moveverb  come go move travel]
        [does_moveverb comes goes travels]
        [do_giveverb  give send]
        [does_giveverb gives sends]
        [is_v is was]
        [are_v are were]
        ;;;
        ;;; comparatives
        [sizecomp bigger smaller wider fatter larger]
        [htcomp taller shorter]
        [distcomp nearer further]

    ];

/* --- Revision History ---------------------------------------------------
--- Aaron Sloman, Oct 19 2010
        Revised version of part of newplaylex.p

 */
