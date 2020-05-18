
-------------------------------------------------------------------------------------
PROJECT WEB MINING 
Kaggle competition: Predict Subreddit comments score
M2 Statistics and Econometrics - April 2020
-------------------------------------------------------------------------------------
Authors: 
Guillem Fortó (21502168)
Jade Henry (21400315)
-------------------------------------------------------------------------------------


TABLE OF CONTENTS
-----------------
**OBJECTIVE
**ARCHIVE FILES
**PRACTICAL GUIDE
**MORE INFORMATION ABOUT THE NOTEBOOKS CONTENT
	**ENGINEERED FEATURES
	**MODELS USED
	**EXTERNAL INFORMATIVE RESOURCES


OBJECTIVE
---------
The aim of this project is to predict the number of upvotes (1) of comments from the
Reddit website based on some available data and additional engineered features.

(1) Remark: the variable to predict is "ups" but it actually corresponds to the score
obtained by a comment. The score is the difference between the number of upvotes and 
the number of downvotes. Hence, there exist some negative values in our target variable.


ARCHIVE FILES
-------------
All files needed are in the archive file (the_dark_side_of_eigenvectors):

	
-- 2 NOTEBOOKS:
	 - 1getting_the_features.ipynb 
	 - 2modelisation.ipynb 
	 

-- 1 CSV FILE
	 - best_submission.csv : submission file for Kaggle

-- 1 PKL FILE
	 - https://www.dropbox.com/s/yz43zs1oj11cgh3/df_all_features.pkl?dl=0
	 to download it




PRACTICAL GUIDE
---------------
Each notebook can be run independently.


-- If you want to check how we got the engineered features, open 1getting_the_features.ipynb.

Remarks: 

	- If the data is in the same folder than the notebook, then you don't need to add anything. 
	  Otherwise, set the directory of the archive file, using this command:
		import os 
		os.chdir("...")
				

	- In order to run this code, you might need to install the following libraries:
		!pip multiprocessing
		!pip vaderSentiment
		!pip urllib
		!pip emoji
		!pip install --upgrade vaderSentiment
		!pip install parfit
		!pip install tensorflow
	


-- If you want to go directly to the prediction part, open 2modelisation.ipynb.
   This notebook needs the external data final_df.pkl.
   

-- If you want to check the score obtained with our best submission, use:
		import pandas as pd
		the_dark_side_of_eigenvectors_pred = pd.read_csv("submission_4_13_.._...csv")





MORE INFORMATION ABOUT THE NOTEBOOKS CONTENT
--------------------------------------------

	NOTEBOOK 1: ENGINEERED FEATURES
	-------------------------------
	
		-- Content based features (attached urls, link to other comments, text mining...)
		-- Structural features (depth, author centrality...)
		-- Stylometric features (sentiment analysis)



	NOTEBOOK 2: MODELS USED
	---------------------------
	
		-- Before submitting, we tested our model on a validation set, drawn from the train set.
		-- We tried Random Forest, XGBoost algorithm and a Neural Network.
		-- The evaluation metric is the Mean Average Error (MAE).
		
		
	
	EXTERNAL INFORMATIVE RESOURCES
	------------------------------
	
	Understandig of link-id, parent_id and names:
	https://www.reddit.com/dev/api/
	








