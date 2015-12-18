# GCSE Word list

The goal of "vortlisto" ("word list") is to produce a machine-readable vocabulary of words for an (English-speaking) Esperanto learner.

The source is a curated word list produced as part of a UK high school (GCSE) Esperanto syllabus that ran until 1996. The advantages of this source are that there's some academic consensus around the selection; the words are grouped by linguistic categories; "basic" words are tagged; and perhaps most importantly this list exists in a somewhat machine-readable state online already, thanks to [Bill Walker](http://www.wgtw.co.uk/) who created [a giant HTML page of it all](http://home.btclick.com/ukc802510745/eo/vortlist/gcselist.htm).
  
## Contents

1. `gcselist.htm` - this is the original HTML document
2. `gcselist.fixed.htm` - the original with some manual markup fixes to aid parsing
3. `csv/*.csv` - a series of CSV files containing Esperanto and English words whose names reflect the category and level
4. `vortlisto.rb` - a Ruby program to convert the fixed HTML doc into the CSV files

## Usage

If you wish to use `vortlisto.rb`'s download capability `gem install httparty`.

Run with `./vortlisto.rb`; run time is about a half second.

## Use in other applications

### Cerego

So far, I've successfully uploaded a CSV file directly to [Cerego](https://cerego.com/) a spaced repetition learning site and app. I'm a fan of Cerego since it really seems to work, the UI & UX are pretty good, and [they publish an API](https://docs.google.com/document/u/1/d/1T6hvcS39T7l2lrhuDKihQmAZuSzVQHvrGtq_OExaUc8/pub).

The first word list I uploaded was the "General Basic" list that contains 396 words. It turns out Cerego struggles with a word list this big; the app spins processing all the data (there's a lot of work per-word for its learning algorithm). The other issue is that Cerego will present the words in the order they're uploaded which currently means grinding through a giant alphabetized list. Cerego is already full of progress markers so alphabetizing only seems to be a disadvantage.

#### Next steps

The "General Basic" list needs to be made much smaller. Two options are arranging into chunks of say 40 words by observed frequency (so learn most common words first) and by additional category like "color", "prepositions", etc. Those subcategories could also be arranged by frequency if only to break up the alphabetizing.

## Statistics

Here is a list of word counts in each section and level,

```
$ wc -l *-basic.csv | sort -n
      15 house_and_home-basic.csv
      23 money-basic.csv
      32 weather-basic.csv
      39 places-basic.csv
      42 affixes-basic.csv
      46 services-basic.csv
      50 health_and_welfare-basic.csv
      51 language-basic.csv
      73 travel-basic.csv
      92 life_at_home-basic.csv
      95 shopping-basic.csv
     106 free_time_entertainment-basic.csv
     107 holidays-basic.csv
     119 education_and_career-basic.csv
     142 relations_with_others-basic.csv
     158 food_and_drink-basic.csv
     266 personal_identification-basic.csv
     386 general-basic.csv
    1842 total
$ wc -l *-advanced.csv | sort -n
       9 house_and_home-advanced.csv
      27 places-advanced.csv
      30 money-advanced.csv
      30 services-advanced.csv
      30 weather-advanced.csv
      31 life_at_home-advanced.csv
      57 language-advanced.csv
      57 shopping-advanced.csv
      65 health_and_welfare-advanced.csv
      65 travel-advanced.csv
      71 education_and_career-advanced.csv
      71 holidays-advanced.csv
      91 food_and_drink-advanced.csv
      93 free_time_entertainment-advanced.csv
     107 personal_identification-advanced.csv
     152 relations_with_others-advanced.csv
     986 total
```

## Credits

*   [Northern Examinations and Assessment Board](https://en.wikipedia.org/wiki/NEAB) (now part of [AQA](http://www.aqa.org.uk)) for providing a nationally accredited Esperanto exam and this word list
*   [Bill Walker](http://www.wgtw.co.uk/) for converting that word list to [HTML](http://home.btclick.com/ukc802510745/eo/vortlist/gcselist.htm)
*   Paul Makepeace for this package
