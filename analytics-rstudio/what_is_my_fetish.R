library('fastmatch')
source('_tagged.R')
source('_util.R')

fetishes = list(
    bdsm = c('ball_gag', 'bondage', 'bdsm', 'bound', 'chastity', 'chastity_cage', 'dungeon', 'gag', 'handcuffs', 'rope_bondage', 'saint_andrew\'s_cross', 'spreader_bar', 'struggling', 'wrist_cuff', 'suspension', 'harness', 'noose', 'infantilism'),
    collar = c('collar', 'leash', 'bridle', 'harness', 'cock_and_ball_torture'),
    foot = c('barefoot', 'big_feet', 'feet', 'foot_focus', 'foot_fetish', 'footjob', 'hindpaw', 'humanoid_feet', 'paw', 'pawpads', 'paws', 'plantigrade', 'soles', 'stomping','toe_claws', 'toes', 'trampling'),
    slave = c('cage', 'dungeon', 'leash', 'master', 'master/slave', 'slave', 'domination'),
    roleplay = c('age_play', 'pony_play', 'pet', 'pet_play', 'role_play', 'infantilism'),
    forced = c('crying', 'nonconsensual', 'forced', 'questionable_consent', 'rape', 'snuff'),
    urine = c('watersports', 'urine', 'peeing', 'wetting', 'wet_diaper'),
    young = c('wet_diaper', 'diaper', 'young', 'cub', 'size_difference', 'flat_chested', 'small_penis', 'shota', 'child', 'baby', 'loli', 'age_difference', 'father', 'babyfur'),
    scat = c('scat', 'feces', 'messy_diaper', 'soiling_diaper', 'pooping'),
    bestiality = c('human_on_feral', 'feral_on_human', 'bestiality', 'male_on_feral', 'zoophilia', 'feral_penetrating_humanoid', 'feral_penetrating_human', 'feral_penetrating_anthro', 'female_on_feral', 'human_focus', 'interspecies', 'male_bestiality', 'canine_penis', 'knot', 'animal_penis', 'animal_genitalia', 'quadruped', 'human_on_anthro'),
    mind = c('hypnosis', 'mind_control'),
    obese = c('obese', 'overweight', 'big_belly'),
    feral = c('feral', 'animal_genitalia', 'multi_breast', 'animal_penis', 'all_fours'),
    transformation = c('transformation', 'gender_transformation', 'mtf_transformation', 'ftm_transformation'),
    tentacles = c('tentacles', 'tentacle_rape', 'tentacle_monster'),
    anal = c('anal', 'anal_penetration', 'male_penetrating', 'cum_in_ass'),
    gore = c(v)
)
preferences = list(
    male = c('male', 'penis', 'dickgirl', 'gay', 'shota'),
    herm = c('herm', 'transgender', 'dickgirl', 'futa'),
    female = c('female', 'lesbian', 'pussy', 'vagina', 'breasts', 'pussy', 'loli'),
    male.male = c('male/male', 'male_penetrating', 'gay', 'frottage'),
    male.female = c('male/female', 'straight', 'impregnation'),
    female.female = c('female/female', 'lesbian'),
    safe = c('rating:s'),
    questionable = c('rating:q'),
    explicit = c('rating:e'),
    digital = c('digital_media_(artwork)'),
    traditional = c('traditional_media_(artwork)')
)
species = list(
    canine = c('canine', 'wolf', 'dog', 'fox', 'werewolf'),
    feline = c('feline', 'cat', 'lion', 'tiger', 'cheetah', 'leopard', 'panther', 'lynx'),
    equine = c('equine', 'horse', 'pegasus', 'unicorn', 'pony', 'donkey'),
    scalie = c('scalie', 'reptile', 'lizard', 'snake', 'crocodile', 'alligator', 'western_dragon', 'scales'),
    rodent = c('rodent', 'lagomorph'),
    mustelid = c('mustelid'),
    cetacean = c('cetacean', 'dolphin', 'whale', 'orca', 'killer_whale'),
    avian = c('avian', 'bird', 'wing'),
    fantasy = c('pegasus', 'unicorn', 'gryphon', 'chimera', 'dragon', 'centaur', 'mermaid', 'sphinx', 'naga'),
    pokemon = c('pok??mon')
)

interests_of_user <- function (username)
{
    return(interests_of(sprintf('fav:%s', username)))
}

interests_of_artist <- function (artist)
{
    return(interests_of(sprintf('artist:%s', artist)))
}

interests_of <- function (tag)
{
    count <- list(fetishes = fetishes, preferences = preferences, species = species)

    tmp.posts <- posts
    tmp.tags <- posts.tags
    posts <<- tagged(tag)
    posts.tags <<- subset(posts.tags, id %in% posts$id)
    count[['total']] <- nrow(posts)

    for (group in names(count))
    {
        for (interest in names(count[[group]]))
        {
            tags <- count[[group]][[interest]]
            tags <- paste('-', tags, sep = '')

            count[[group]][[interest]] <- (count[['total']] - howmanytagged(tags)) / count[['total']]
        }
    }

    posts <<- tmp.posts
    posts.tags <<- tmp.tags

    return(count)
}

plot_interests_of <- function (tags)
{
    count <- interests_of(tags)
    internal_plot(tags, count)
}

plot_user_interests <- function (username)
{
    count <- interests_of_user(username)
    username = sprintf('%s***%s', substr(username, 1, 1), substr(username, nchar(username), nchar(username)))
    internal_plot(username, count)
}

plot_artist_interests <- function (artist)
{
    count <- interests_of_artist(artist)
    internal_plot(artist, count)
}

internal_plot <- function (name, count)
{
    par(mar = c(7, 5, 3, 3))
    par(mfrow = c(3, 1))

    barplot(
        as.numeric(count[['fetishes']]),
        names.arg = names(count[['fetishes']]),
        col = rainbow(length(count[['fetishes']])),
        main = sprintf('Fetishes of %s (%d Posts)', name, count[['total']]),
        ylab = 'Relative Number of Posts',
        ylim = c(0, 1),
        beside = TRUE,
        las = 2
    )
    barplot(
        as.numeric(count[['preferences']]),
        names.arg = names(count[['preferences']]),
        col = rainbow(length(count[['preferences']])),
        main = 'Preferences',
        ylab = 'Relative Number of Posts',
        ylim = c(0, 1),
        beside = TRUE,
        las = 2
    )
    barplot(
        as.numeric(count[['species']]),
        names.arg = names(count[['species']]),
        col = rainbow(length(count[['species']])),
        main = 'Species',
        ylab = 'Relative Number of Posts',
        ylim = c(0, 1),
        beside = TRUE,
        las = 2
    )
}