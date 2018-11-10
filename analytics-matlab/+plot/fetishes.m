function varargout = fetishes(varargin)

    themes = struct();
    themes.bdsm = {'ball_gag', 'bondage', 'bdsm', 'bound', 'chastity', 'chastity_cage', 'dungeon', 'gag', 'handcuffs', 'rope_bondage', 'saint_andrew''s_cross', 'spreader_bar', 'struggling', 'wrist_cuff', 'suspension', 'harness', 'noose', 'infantilism'};
    themes.collar = {'collar', 'leash', 'bridle', 'harness', 'cock_and_ball_torture'};
    themes.foot = {'barefoot', 'big_feet', 'foot_focus', 'foot_fetish', 'footjob', 'soles', 'stomping', 'trampling'};
    themes.slave = {'cage', 'dungeon', 'leash', 'master', 'master/slave', 'slave', 'domination'};
    themes.roleplay = {'age_play', 'pony_play', 'pet', 'pet_play', 'role_play', 'infantilism'};
    themes.forced = {'crying', 'nonconsensual', 'forced', 'questionable_consent', 'rape', 'snuff'};
    themes.urine = {'watersports', 'urine', 'peeing', 'wetting', 'wet_diaper'};
    themes.young = {'wet_diaper', 'diaper', 'young', 'cub', 'shota', 'child', 'baby', 'loli', 'age_difference', 'father', 'babyfur'};
    themes.scat = {'scat', 'feces', 'messy_diaper', 'soiling_diaper', 'pooping'};
    themes.vore = {'vore'};
    themes.bestiality = {'human_on_feral', 'feral_on_human', 'bestiality', 'male_on_feral', 'zoophilia', ['pok' 233 'philia'], 'digiphilia', 'feral_penetrating_humanoid', 'feral_penetrating_human', 'feral_penetrating_anthro', 'female_on_feral', 'male_bestiality', 'human_on_anthro'};
    themes.mind = {'hypnosis', 'mind_control'};
    themes.obese = {'obese', 'overweight', 'big_belly'};
    %themes.feral = {'feral', 'all_fours', 'quadruped'};
    themes.tf = {'transformation', 'gender_transformation', 'mtf_transformation', 'ftm_transformation'};
    themes.tentacles = {'tentacles', 'tentacle_rape', 'tentacle_monster'};
    themes.anal = {'anal', 'anal_penetration', 'cum_in_ass'};
    themes.vaginal = {'vaginal', 'vaginal_penetration', 'cum_in_pussy'};
    themes.gore = {'necrophilia', 'death', 'gore', 'blood', 'snuff', 'disembowelment', 'intestines', 'torture', 'asphyxiation', 'hanged', 'wound', 'hard_vore', 'crush', 'guts'};
    themes.oviposition = {'oviposition'};
    themes.result = zeros(numel(varargin), 19);

    prefs = struct();
    prefs.male = {'male', 'penis', 'dickgirl', 'gay', 'shota'};
    prefs.female = {'female', 'lesbian', 'pussy', 'vagina', 'breasts', 'pussy', 'loli'};
    prefs.inter = {'intersex', 'herm', 'dickgirl', 'futa', 'cuntboy'};
    prefs.m_m = {'male/male', 'male_penetrating', 'gay', 'frottage'};
    prefs.m_f = {'male/female', 'straight', 'impregnation'};
    prefs.f_f = {'female/female', 'lesbian'};
    prefs.safe = {'rating:s'};
    prefs.qstnbl = {'rating:q'};
    prefs.explicit = {'rating:e'};
    prefs.digital = {'digital_media_(artwork)'};
    prefs.traditnl = {'traditional_media_(artwork)'};
    prefs.result = zeros(numel(varargin), 11);

    species = struct();
    species.canine = {'canine', 'wolf', 'dog', 'fox', 'werewolf'};
    species.feline = {'feline', 'cat', 'lion', 'tiger', 'cheetah', 'leopard', 'panther', 'lynx'};
    species.equine = {'equine', 'horse', 'pegasus', 'unicorn', 'pony', 'donkey'};
    species.scalie = {'scalie', 'reptile', 'lizard', 'snake', 'crocodile', 'alligator', 'western_dragon', 'scales'};
    species.rodent = {'rodent', 'lagomorph'};
    species.mustelid = {'mustelid'};
    species.cetacean = {'cetacean', 'dolphin', 'whale', 'orca', 'killer_whale'};
    species.avian = {'avian', 'bird', 'wing'};
    species.fantasy = {'pegasus', 'unicorn', 'gryphon', 'chimera', 'dragon', 'centaur', 'mermaid', 'sphinx', 'naga'};
    species.pokemon = {['pok' 233 'mon']};
    species.result = zeros(numel(varargin), 10);

    ntags = numel(varargin);
    for itag = 1:ntags
        tag = varargin{itag};
        baseline = tagged(tag);
        total = numel(baseline);

        categories = fieldnames(themes);
        for icat = 1:numel(categories)-1
            inverse_tags = strcat('-', themes.(categories{icat}));
            themes.result(itag, icat) = numel(setdiff(baseline, tagged(inverse_tags))) / total;
        end

        categories = fieldnames(prefs);
        for icat = 1:numel(categories)-1
            inverse_tags = strcat('-', prefs.(categories{icat}));
            prefs.result(itag, icat) = numel(setdiff(baseline, tagged(inverse_tags))) / total;
        end

        categories = fieldnames(species);
        for icat = 1:numel(categories)-1
            inverse_tags = strcat('-', species.(categories{icat}));
            species.result(itag, icat) = numel(setdiff(baseline, tagged(inverse_tags))) / total;
        end
    end

    subplot = @(m,n,p) vendor.subplot(m, n, p, [0.1 0], [0.1 0.05], [0.1 0.05]);

    subplot(3,1,1);
    plotbar(themes);

    subplot(3,1,2);
    plotbar(prefs);
    l = legend(plot.label(varargin), 'Location', 'East', 'Interpreter', 'none');
    l.Position = l.Position + [0.04 0 0 0];

    subplot(3,1,3);
    plotbar(species);

    export.invertcolors();

    if nargout > 0
        fig = figure();
        varargout{1} = fig;
    end

    if nargout > 1
        varargout{1} = struct('themes', themes, 'prefs', prefs, 'species', species);
    end

end

function plotbar(values)

    bar(values.result.' * 100);

    labels = fieldnames(values);
    labels = labels(1:end-1);
    xticks(1:length(labels));
    xticklabels(strrep(labels, '_', '\_'));
    xtickangle(25);

    ylabel('% of samples')
    %ylim([0 100])

    a = gca();
    a.FontSize = 10; % pt
    a.FontWeight = 'bold';

end
