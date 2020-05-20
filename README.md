# Reddit Upvote Prediction &nbsp; &nbsp; <img alt="reddit_logo.png" src="reddit_logo.png" width="50" height="50">

This Kaggle competition consisted in predicting the score of over a million Reddit comments using some already available attributes, as well as multiple additional features that we engineered ourselves.<br>
The data handled came from the [Reddit](https://fr.wikipedia.org/wiki/Reddit) website. More specifically, it contained all comments scraped from the [AskReddit subreddit](https://www.reddit.com/r/AskReddit/), that were published on the platform during May 2015.


**Remark:** the variable to predicted is "ups" but it actually corresponds to the score
obtained by a comment. The score is the difference between the number of upvotes and
the number of downvotes. Hence, there existed some negative values in our target variable.

**Authors:** Guillem Fortó / Jade Henry

**Date:** March - April 2020<br>
This project was part of the Web Mining and Databases courses of the M2 Statistics and Econometrics, at Toulouse School of Economics.

## Installation of libraries
You'll need Python 3 installed with pip.<br>
Here is a non-exhaustive list of dependencies you might have to install:
```bash
pip install multiprocessing
pip install urllib
pip install emoji
pip install vaderSentiment
pip install parfit
pip install tensorflow
```
If you also want to run the .sql files, you'll need to install [sqlite3](https://www.sqlite.org/index.html).

## Running the code
Start by downloading the necessary data files:
- `comments_students.csv` contains the initial basic features available on Kaggle and the variable ups to predict: https://www.dropbox.com/s/coeojwrby3g6slo/comments_students.csv?dl=0
- `df_all_features.pkl` is the final dataframe containing all the features: https://www.dropbox.com/s/rufg783pt9svn1b/df_all_features.pkl?dl=0

Each notebook (.ipynb files) can be run independently. If you want to check how we got the engineered features, start by having a look at `1getting_the_features.ipynb`. Otherwise, you can directly go to `2modelisation.ipynb` and import the downloaded dataframe (pickle file) in order to start making predictions.

If you want to check the score obtained with our best submission, use:
```bash
import pandas as pd
best = pd.read_csv("best_submission.csv")
```

## Additional information

- **database_part1.sql** <br>
We didn't mention it so far, but we also used SQL Data Definition Language to create the tables necessary to reconstruct the provided relational schema from the initial file `comments_students.csv`. All the commands are in this .sql script, and are meant to be executed using **sqlite3** (all the detailed steps are in the document).

- **database_part2.sql + exploratory_analysis.py**<br>
Once the relational schema was build, this was useful to run some preliminar exploratory analysis on the different tables. Some basic queries that could be run with SQL directly are in the .sql file, and more advanced ones are in the Python file.

- **Jupyter notebooks**
	- **1getting_the_features.ipynb**
		- Content based features (attached urls, link to other comments, text mining...). Please find the complete list of features in `all_features.txt`
		- Structural features (depth, author centrality...)
		- Stylometric features (sentiment analysis)

	- **2modelisation.ipynb**
		- Before submitting, we tested our model on a validation set, drawn from the train set.
		- We tried a Random Forest, XGBoost, and a Neural Network.
		- The evaluation metric is the Mean Average Error (MAE).


## External informative resources
- Understanding of link-id, parent_id and names: https://www.reddit.com/dev/api/
