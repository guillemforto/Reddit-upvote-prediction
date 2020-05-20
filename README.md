# Reddit Upvote Prediction

<img alt="reddit_logo.png" src="/Users/guillemforto/github/reddit_upvote_prediction/reddit_logo.png" width="50" height="50"> <br>

This Kaggle competition consisted in predicting the score of over a million Reddit comment scores from multiple available comment attributes, as well as addition features that we engineered.<br>
The data handled came from the [Reddit](https://fr.wikipedia.org/wiki/Reddit) website. More specifically, the dataset contained all comments on the [AskReddit subreddit](https://www.reddit.com/r/AskReddit/) published on the platform during May 2015.

**Authors:** Guillem Fortó / Jade Henry

**Date:** April 2020<br>
This project was part of the Web Mining course of the M2 Statistics and Econometrics, at Toulouse School of Economics.

**Remark:** the variable to predicted is "ups" but it actually corresponds to the score
obtained by a comment. The score is the difference between the number of upvotes and
the number of downvotes. Hence, there exist some negative values in our target variable.

## Installation of libraries
You'll need Python 3 installed with pip.<br>
Here is an exhaustive list of dependencies you might want to install:
```bash
pip install multiprocessing
pip install urllib
pip install emoji
pip install vaderSentiment
pip install parfit
pip install tensorflow
```


## Running the code
Start by downloading the necessary data files:
- `comments_students.csv` contains the initial basic features available on Kaggle and the variable ups to predict: https://www.dropbox.com/s/coeojwrby3g6slo/comments_students.csv?dl=0
- `df_all_features.pkl`: https://www.dropbox.com/s/rufg783pt9svn1b/df_all_features.pkl?dl=0

Each notebook (.ipynb files) can be run independently. If you want to check how we got the engineered features, start by having a look at `1getting_the_features.ipynb`. Otherwise, you can directly go to `2modelisation.ipynb` and import the downloaded dataframe (.pkl file) containing all the engineered features in order to start making predictions.

If you want to check the score obtained with our best submission, use:
```bash
import pandas as pd
best = pd.read_csv("best_submission.csv")
```

## Additional information on the notebooks content
	NOTEBOOK 1 : ENGINEERED FEATURES
	-------------------------------
		- Content based features (attached urls, link to other comments, text mining...)
		- Structural features (depth, author centrality...)
		- Stylometric features (sentiment analysis)

	Find the complete list of features in all_features.txt


	NOTEBOOK 2 : MODELS USED
	---------------------------
		-- Before submitting, we tested our model on a validation set, drawn from the train set.
		-- We tried a Random Forest, XGBoost, and a Neural Network.
		-- The evaluation metric is the Mean Average Error (MAE).


	EXTERNAL INFORMATIVE RESOURCES
	------------------------------
	Understandig of link-id, parent_id and names: https://www.reddit.com/dev/api/
