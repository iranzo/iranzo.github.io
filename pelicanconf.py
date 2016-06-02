# -*- coding: utf-8 -*- #
# Libraries to install
#


from __future__ import unicode_literals

import os
import datetime

AUTHOR = u'Pablo Iranzo Gómez'
SITENAME = u"Pablo Iranzo Gómez's blog"
SITEURL = u'http://iranzo.github.io'

PATH = 'content'

TIMEZONE = 'Europe/Madrid'

DEFAULT_LANG = u'en'
DEFAULT_CATEGORY = 'tech'

# Feed generation is usually not desired when developing
# FEED_ALL_ATOM = None
# CATEGORY_FEED_ATOM = None
# TRANSLATION_FEED_ATOM = None
# AUTHOR_FEED_ATOM = None
# AUTHOR_FEED_RSS = None

DISPLAY_PAGES_ON_MENU = True

STATIC_PATHS = [
    'imagen',
    'extra/robots.txt',
    'extra/favicon.png'
]

EXTRA_PATH_METADATA = {
    'extra/robots.txt': {'path': 'robots.txt'},
    'extra/favicon.png': {'path': 'favicon.png'}
}

CACHE_CONTENT = False
CACHE_PATH = '.cache'
LOAD_CONTENT_CACHE = False


# Plugins
PLUGIN_PATHS = ['plugins']

PLUGINS = [
    'better_codeblock_line_numbering',
    'better_figures_and_images',
    'related_posts',
    'tag_cloud',
    'sitemap',
    'category_order',
    # 'yuicompressor',
]

FAVICON = 'extra/favicon.png'
THEME = 'themes/octopress'
FILENAME_METADATA = '(?P<date>\d{4}-\d{2}-\d{2})-(?P<slug>.*)'
USE_FOLDER_AS_CATEGORY = False

SEARCH_BOX = False


# URL Settings to be compatible with octopress
ARTICLE_URL = 'blog/{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'
ARTICLE_SAVE_AS = 'blog/{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'

YEAR_ARCHIVE_URL = 'blog/archive/{date:%Y}/index.html'
YEAR_ARCHIVE_SAVE_AS = 'blog/archive/{date:%Y}/index.html'

MONTH_ARCHIVE_URL = 'blog/archive/{date:%Y}/{date:%m}/index.html'
MONTH_ARCHIVE_SAVE_AS = 'blog/archive/{date:%Y}/{date:%m}/index.html'

CATEGORY_URL = 'blog/category/{slug}/index.html'
CATEGORY_SAVE_AS = 'blog/category/{slug}/index.html'

TAG_URL = 'blog/tag/{slug}/index.html'
TAG_SAVE_AS = 'blog/tag/{slug}/index.html'

PAGE_URL = '{slug}/index.html'
PAGE_SAVE_AS = '{slug}/index.html'

AUTHOR_SAVE_AS = ''
AUTHORS_SAVE_AS = ''

ARCHIVES_URL = 'blog/archives/index.html'
ARCHIVES_SAVE_AS = 'blog/archives/index.html'

CATEGORIES_URL = 'blog/categories/index.html'
CATEGORIES_SAVE_AS = 'blog/categories/index.html'

TAGS_URL = 'blog/tags/index.html'
TAGS_SAVE_AS = 'blog/tags/index.html'


DIRECT_TEMPLATES = ['index', 'tags', 'categories', 'archives']


# Blogroll
# LINKS = (('Pelican', 'http://getpelican.com/'),
#         ('Python.org', 'http://python.org/'),
#         ('Jinja2', 'http://jinja.pocoo.org/'),
#         ('You can modify those links in your config file', '#'),)

# Social widget

# SOCIAL = [
#     ('github', 'https://github.com/iranzo'),
# ]

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

# better codeblock
MD_EXTENSIONS = [
    'codehilite(css_class=highlight,linenums=False)',
    'extra'
]

# related_posts
RELATED_POSTS_MAX = 5

# tag_cloud
TAG_CLOUD_STEPS = 10
TAG_CLOUD_MAX_ITEMS = 20
TAG_CLOUD_SORTING = 'size-rev'

# sitemap
SITEMAP = {
    'format': 'xml',
    'priorities': {
        'articles': 0.5,
        'indexes': 0.5,
        'pages': 0.5
    },
    'changefreqs': {
        'articles': 'monthly',
        'indexes': 'daily',
        'pages': 'monthly'
    }
}

# category_order
CATEGORIES_ORDER_BY = 'size-rev'
TAGS_ORDER_BY = 'size-rev'

SITE_UPDATED = datetime.date.today()


#octopress theme
GITHUB_USER = "iranzo"
GITHUB_REPO_COUNT= 5
GITHUB_SKIP_FORK= True
GITHUB_SHOW_USER_LINK= True

TWITTER_USER= "iranzop"
GOOGLE_PLUS_ID= "115967682482067873883"
FACEBOOK_LIKE=True

GOOGLE_PLUS_ONE= True
GOOGLE_PLUS_HIDDEN= False

GOOGLE_ANALYTICS="UA-81705-12"



