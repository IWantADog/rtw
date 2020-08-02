public: yes
tags: [rstblog]
summary: |
    rstblog的作者及基本使用介绍。如果你对rstblog感兴趣，这会帮到你。

关于rstblog
=============

rstblog的开发者是 Armin Ronacher，一个十分厉害的pythoner。

如果感兴趣可以前往他的
`个人博客 <https://lucumr.pocoo.org/>`_ 或
`github <https://github.com/mitsuhiko>`_ 。

`rstblog <https://github.com/mitsuhiko/rstblog>`_ 存放着系统源码。
`Armin Ronacher's post <https://github.com/mitsuhiko/lucumr>`_ 存放作者本人的提交。

**rstblog** 的基本介绍
----------------------------

先将rst文件渲染为html，再通过
`jinja2 <https://jinja.palletsprojects.com/en/2.11.x/>`_ 模版系统将渲染后的html与模版拼接，最后将生成的html写入文件。

**rstblog** 的基础是rst文件。关于rst文件的详细信息，可以参见
`wiki <https://en.wikipedia.org/wiki/ReStructuredText>`_ 和 
`Quick reStructuredText <https://docutils.sourceforge.io/docs/user/rst/quickref.html>`_ 。
对于习惯使用md的朋友可能会感到麻烦。



