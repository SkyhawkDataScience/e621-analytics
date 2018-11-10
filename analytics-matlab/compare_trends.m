
plot.historybar('type:jpg', 'type:png', 'type:gif', 'type:swf', 'type:webm')
export.clipboard()
export.fourbythree('results/trend_type_other')

plot.historybar({'my_little_pony', 'rating:s'}, {'my_little_pony', 'rating:e'})
export.clipboard()
export.fourbythree('results/trend_mlp_rating')

%% fandoms
plot.historybar('the_lion_king', 'zootopia', 'my_little_pony')
export.clipboard()

plot.historybar('pokémon', 'digimon', 'naruto', 'inuyasha')
export.clipboard()

plot.historybar('how_to_train_your_dragon', 'hotel_transylvania')
export.clipboard()
