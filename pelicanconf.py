# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

import datetime

AUTHOR = u'Pablo Iranzo Gómez'
SITENAME = u"Pablo Iranzo Gómez's blog"
SITESUBTITLE = u'A bunch of unrelated data'
SITEURL = u'/'
TWITTER_USERNAME = "iranzop"
AMAZON_ONELINK = "b63a2115-85f7-43a9-b169-5f4c8c275655"

PATH = 'content'

TIMEZONE = 'Europe/Madrid'

# Put as draft content in the future
WITH_FUTURE_DATES = False

# Put full text in RSS feed
RSS_FEED_SUMMARY_ONLY = False

DEFAULT_LANG = u'en'
DEFAULT_CATEGORY = 'tech'

# Feed generation is usually not desired when developing

FEED_ALL_ATOM = 'feeds/all.atom.xml'
FEED_ALL_RSS = 'feeds/all.rss'

CATEGORY_FEED_ATOM = 'feeds/{slug}.atom.xml'
CATEGORY_FEED_RSS = 'feeds/{slug}.rss'
TRANSLATION_FEED_ATOM = 'feeds/{lang}.atom.xml'
TRANSLATION_FEED_RSS = 'feeds/{lang}.rss'
AUTHOR_FEED_ATOM = 'feeds/{slug}.atom.xml'
AUTHOR_FEED_RSS = 'feeds/{slug}.rss'
TAG_FEED_ATOM = 'feeds/tag_{slug}.atom.xml'
TAG_FEED_RSS = 'feeds/tag_{slug}.rss'

DISPLAY_PAGES_ON_MENU = True

STATIC_PATHS = [
    'imagen',
    'extra/robots.txt',
    'extra/favicon.ico',
    'extra/keybase.txt',
    'extra/google3bc953001343abe6'
]

EXTRA_PATH_METADATA = {
    'extra/keybase.txt': {'path': 'keybase.txt'},
    'extra/robots.txt': {'path': 'robots.txt'},
    'extra/favicon.ico': {'path': 'favicon.ico'},
    'extra/google3bc953001343abe6' : {'path': 'google3bc953001343abe6.html'}
}

CACHE_CONTENT = False
CACHE_PATH = '.cache'
LOAD_CONTENT_CACHE = False

# Plugins
PLUGIN_PATHS = ['plugins']

PLUGINS = ['sitemap', 'extract_toc', 'tipue_search', 'liquid_tags',
           'neighbors', 'render_math', 'related_posts', 'share_post',
           'series']
           # 'better_codeblock_line_numbering'
           # 'better_figures_and_images' 

# assets

FAVICON = 'extra/favicon.ico'
THEME = 'themes/elegant'

#elegant
TYPOGRIFY = True
RECENT_ARTICLE_SUMMARY = True
RESPONSIVE_IMAGES = True

LANDING_PAGE_ABOUT = {'title': 'A bunch of unrelated data',
                      'details': """<p>This website contains both documentation and setups that could be interesting to you.</p><p>I hope that this results interesting or at least you get some ideas :-)</p><p>You can find more information on me on <a href="https://iranzo.github.io/cv/">my profile</a></p>"""}


PROJECTS = [{'name': 'Redken on telegram', 'url': 'https://t.me/redken_bot',
             'description': 'A Telegram bot with support for Karma, RSS Feeds, Quotes, etc'},
            {'name': 'Citellus', 'url': 'https://citellus.org',
             'description': 'Troubleshooting automation tool with easy to contribute rules'},
            {'name': 'Pets at Github', 'url': 'https://github.com/iranzo',
             'description': 'Other projects at Github website'}]

MARKDOWN = {
    'extension_configs': {
        'markdown.extensions.codehilite': {
            'css_class': 'highlight',
            'linenums': True
        },
        'markdown.extensions.extra': {},
        'markdown.extensions.toc': {
            'permalink': 'true'
        },
        'markdown.extensions.meta': {},
    },
    'output_format': 'html5',
}

DIRECT_TEMPLATES = (('index', 'tags', 'categories','archives', 'search', '404'))

# Elegant Labels
SOCIAL_PROFILE_LABEL = u'Stay in Touch'
RELATED_POSTS_LABEL = 'Keep Reading'
SHARE_POST_INTRO = 'Like this post? Share on:'
COMMENTS_INTRO = u''


FILENAME_METADATA = '(?P<date>\d{4}-\d{2}-\d{2})-(?P<slug>.*)'
USE_FOLDER_AS_CATEGORY = False

SEARCH_BOX = False


# URL Settings to be compatible with octopress
ARTICLE_URL = 'blog/{date:%Y}/{date:%m}/{date:%d}/{slug}/'
ARTICLE_SAVE_AS = 'blog/{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'

ARTICLE_LANG_URL = 'blog/{date:%Y}/{date:%m}/{date:%d}/{slug}-{lang}/'
ARTICLE_LANG_SAVE_AS = 'blog/{date:%Y}/{date:%m}/{date:%d}/{slug}-{lang}/index.html'

YEAR_ARCHIVE_URL = 'blog/archive/{date:%Y}/'
YEAR_ARCHIVE_SAVE_AS = 'blog/archive/{date:%Y}/index.html'

MONTH_ARCHIVE_URL = 'blog/archive/{date:%Y}/{date:%m}/'
MONTH_ARCHIVE_SAVE_AS = 'blog/archive/{date:%Y}/{date:%m}/index.html'

CATEGORY_URL = 'blog/category/{slug}/'
CATEGORY_SAVE_AS = 'blog/category/{slug}/index.html'

TAG_URL = 'blog/tag/{slug}/'
TAG_SAVE_AS = 'blog/tag/{slug}/index.html'

PAGE_URL = '{slug}/'
PAGE_SAVE_AS = '{slug}/index.html'

AUTHOR_SAVE_AS = ''
AUTHORS_SAVE_AS = ''

ARCHIVES_URL = 'blog/archives/'
ARCHIVES_SAVE_AS = 'blog/archives/index.html'

CATEGORIES_URL = 'blog/categories/'
CATEGORIES_SAVE_AS = 'blog/categories/index.html'

TAGS_URL = 'blog/tags/'
TAGS_SAVE_AS = 'blog/tags/index.html'

LINKS = (('Redken on telegram', 'https://t.me/redken_bot'),
         ('RHJobs channel on TG', "https://t.me/rhjobs"),)

SOCIAL = (('twitter', 'http://twitter.com/iranzop'),
          ('github', 'http://github.com/iranzo'),)

DEFAULT_PAGINATION = 5
DEFAULT_ORPHANS = 0

PAGINATION_PATTERNS = (
    (1, '{base_name}/', '{base_name}/index.html'),
    (2, '{base_name}/page/{number}/', '{base_name}/page/{number}/index.html'),
)


# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = True

# better codeblock
MARKDOWN = {
    'extension_configs': {
        'markdown.extensions.codehilite': {'css_class': 'highlight', 'linenums': False},
        'markdown.extensions.extra': {},
        'markdown.extensions.meta': {},
    },
    'output_format': 'html5',
}

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

SITE_UPDATED = datetime.date.today()

GOOGLE_ANALYTICS = "UA-81705-12"


# blue-penguin

# provided as examples, they make ‘clean’ urls. used by MENU_INTERNAL_PAGES.
TAGS_URL = 'tags'
TAGS_SAVE_AS = 'tags/index.html'
AUTHORS_URL = 'authors'
AUTHORS_SAVE_AS = 'authors/index.html'
CATEGORIES_URL = 'categories'
CATEGORIES_SAVE_AS = 'categories/index.html'
ARCHIVES_URL = 'archives'
ARCHIVES_SAVE_AS = 'archives/index.html'

# use those if you want pelican standard pages to appear in your menu
MENU_INTERNAL_PAGES = (
    ('Tags', TAGS_URL, TAGS_SAVE_AS),
    ('Archives', ARCHIVES_URL, ARCHIVES_SAVE_AS),
)

DISQUS_SITENAME = "iranzo-github-io"
DISQUS_DISPLAY_COUNTS = True
