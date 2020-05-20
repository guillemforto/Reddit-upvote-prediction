#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 13 09:54:55 2020

M2 TSE STAT-ECO
@author: guillem.forto-cornella@ut-capitole.fr
date: 20.03.2020
last mod: -

NOTE: statistics and graphics on askreddit database
"""
# PACKAGE IMPORTATION
import os

import sqlite3

import pandas as pd
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()

import numpy as np

import random

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib import style
style.use('fivethirtyeight') # embelishment



# SETTING WORKING DIRECTORY
path = '/Users/guillemforto/Desktop/'
os.chdir(path)
os.getcwd()
    


# QUERIES
def nb_comments_per_day(cursor):
    sql_nb_comments_per_day = """  
        SELECT  strftime('%d', date(created_utc, 'unixepoch')) as pub_time,
                COUNT(*)
        FROM comment
        GROUP BY pub_time """
    results = list(cursor.execute(sql_nb_comments_per_day))
    all_dates = [results[i][0] for i in range(len(results))]
    nb_publications = [results[i][1] for i in range(len(results))]
    # plot
    plt.plot_date(all_dates, nb_publications, '-')
    plt.xticks(ticks = all_dates[0::2])
    plt.xlabel('days of May', fontsize = 13)
    plt.ylabel('number of comments posted', fontsize = 13)
    plt.title('Evolution of the number of posts through time')
    plt.show()
    return(results)


def nb_comments_per_weekday(cursor):
    sql_nb_comments_per_weekday = """
        SELECT  strftime('%w', date(created_utc, 'unixepoch')) as pub_day,
                COUNT(*)
        FROM comment
        GROUP BY pub_day """
    results = list(cursor.execute(sql_nb_comments_per_weekday))
    all_dates = [results[i][0] for i in range(len(results))]
    nb_publications = [results[i][1] for i in range(len(results))]
    # plot
    plt.bar(x = all_dates, height = nb_publications)
    plt.xticks(ticks = [0,1,2,3,4,5,6], 
               labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'])
    plt.xlabel('weekdays', fontsize = 13)
    plt.ylabel('number of comments posted', fontsize = 13)
    plt.title('Evolution of the number of posts through the week')
    plt.show()
    return(results)


def top_prolific_authors(cursor, how_many):
    sql_top_authors = """
        SELECT c.author, COUNT(c.name) as nb_comments, AVG(s.score) as avg_score
        FROM comment c, score s
        WHERE c.id = s.id
        GROUP BY c.author
        HAVING nb_comments > 7 
        -- 7 is the average number of comments per author
        ORDER BY avg_score DESC 
        -- we can use the column name because the ORDER BY is after the SELECT"""
    results = list(cursor.execute(sql_top_authors))
    results = results[:how_many]
    print('Results for the top',how_many, 'authors:')
    for row in results:
        print("The author '", row[0], "' published ", row[1], ' comments with an average score of ', row[2], '\n', sep='') # row is a tuple
    final_res = [results[i][0] for i in range(len(results))]
    return(final_res)


def top_comments(cursor):
    sql_top_comments = """  
        SELECT c.body as top_comments, s.score as comm_score
        FROM comment c, score s
        WHERE c.id = s.id
        ORDER BY comm_score DESC
        LIMIT 5 """
    results = list(cursor.execute(sql_top_comments))
    print('Top 5 comments:')
    for i in range(len(results)):
        print(i+1, ". The comment:\n", results[i][0], "\nreceived a score of ", results[i][1], '\n', sep='')
    return(results)


def score_length_curve(cursor):
    # Do the lengthy comments have a higher score on average
    sql_score_length = """
        SELECT LENGTH(c.body) as length, AVG(s.score) as avg_length_score
        FROM comment c, score s
        WHERE c.id = s.id
        GROUP BY length
        ORDER BY avg_length_score DESC """
    results = list(cursor.execute(sql_score_length))
    all_lengths = [results[i][0] for i in range(len(results))]
    all_avg_scores = [results[i][1] for i in range(len(results))]
    # plot
    plt.scatter(x = all_lengths, y = all_avg_scores)
    plt.xlabel('length', fontsize = 13)
    plt.ylabel('score', fontsize = 13)
    plt.title('Evolution of the average score for every possible length')
    plt.show()
    print("The comments with the higher scores seem to be lengthier, but\
          writing a lenghtier comment does not always imply receiving more votes")
    return(results)


def score_gilded_barplots(cursor):
    # Do comments having been gilded at least once have a higher score?
    sql_score_length = """
        SELECT gilded, AVG(s.score) as avg_gilded_score
        FROM comment c, score s
        WHERE c.id = s.id
        GROUP BY gilded """
    results = list(cursor.execute(sql_score_length))
    
    all_gilded = [results[i][0] for i in range(len(results))]
    all_avg_scores = [results[i][1] for i in range(len(results))]
    # plot
    plt.bar(x = all_gilded, height = all_avg_scores)
    plt.xticks(ticks = [1,2,3,4,5,6,7,8,9,11,12])
    plt.xlabel('nb gilded', fontsize = 13)
    plt.ylabel('score', fontsize = 13)
    plt.title('Evolution of the average score for every possible gilded score')
    plt.show()
    print("The comments with the higher scores seem to be lengthier, but\
          writing a lenghtier comment does not always imply receiving more votes")
    return(results)


def most_interesting_comments(cursor):
    sql_top_comments = """  
        SELECT c.body as best_comments, LENGTH(c.body) as length, 
        s.score as comm_score, c.author, gilded
        FROM comment c, score s
        WHERE c.id = s.id
        AND length > 2000
        AND gilded >= 4
        ORDER BY comm_score DESC"""
    results = list(cursor.execute(sql_top_comments))
    print('Top 5 comments:')
    for i in range(len(results)):
        print(i+1, ". The comment:\n", results[i][0], "\npublished by", results[i][3], "had a length of", results[i][1], '\n and received a score of ', results[i][2], 'with ', results[i][4], 'reddit gold stars', sep='')
    return(results)


    


# main program
def main():
    db = 'askreddit.sqlite'
    conn = sqlite3.connect(db)
    cur = conn.cursor()
    
    nb_comments_per_day(cur)
    nb_comments_per_weekday(cur)
    top_prolific_authors(cur, 5) # top 5 prolific authors
    top_comments(cur)
    nb_comments_per_day(cur)
    score_length_curve(cur)
    score_gilded_barplots(cur)
    most_interesting_comments(cur)
    
    conn.close()
    

if __name__ == "__main__":
    # execute only if run as a script
    main()
    








