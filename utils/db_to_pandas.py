import pymysql as db
import pandas as pd
import warnings
warnings.filterwarnings('ignore')

def get_connection():
    con = db.connect(host='localhost', user='jyji', password='123123', db='IMDB', charset='utf8')
    return con

with get_connection() as con:
    SQL = open('./SQL/movie_related_information.sql').read()
    df = pd.read_sql(SQL, con)
    print(df.head())
    df.to_csv('./data/movie_related_information.csv')

with get_connection() as con:
    SQL = open('./SQL/director_related_information.sql').read()
    df = pd.read_sql(SQL, con)
    print(df.head())
    df.to_csv('./data/director_related_information.csv')

movie_df = pd.read_csv('./data/movie_related_information.csv', index_col=[0])
director_df = pd.read_csv('./data/director_related_information.csv', index_col=[0])

def change_regnal_number(x):
    l = x.split(' ')
    if l[1].startswith('('):
        l[1], l[2] = l[2], l[1]
    return ' '.join(l)


movie_df['Actor'] = movie_df['Actor'].apply(change_regnal_number)
director_df['Director'] = director_df['Director'].apply(change_regnal_number)

joined_df = pd.merge(left=movie_df, right=director_df, how='inner', on=['MID', 'Movie', 'Year'])
joined_df = joined_df.drop('MID', axis=1)
joined_df = joined_df[['Actor', 'Director', 'Movie', 'Role', 'Year']]

movie_df.to_csv('./data/movie_related_information.csv')
director_df.to_csv('./data/director_related_information.csv')
joined_df.to_csv('./data/joined_table.csv')

movie_df = pd.read_csv('./data/movie_related_information.csv', index_col=[0])
director_df = pd.read_csv('./data/director_related_information.csv', index_col=[0])
joined_df = pd.read_csv('./data/joined_table.csv', index_col=[0])