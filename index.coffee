Parser = require 'rss-parser'
parser = new Parser()

Feed = (require 'feed').Feed
feed = new Feed
  title: "Pluralistic Bite Sized"

Cheerio = require 'cheerio'

splitItem = (item) =>
  for contentItem in item["content:encoded"].split(/<hr\/>/)
    if contentItem.match(/<p><a name/) and not contentItem.match(/bragsheet/)
      contentItem += '
<hr/>
<small>
  <p>
  This work is derived from the original Pluralistic RSS feed. That work is licensed under a <a href="https://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 license</a>. That means you can use it any way you like, including commercially, provided that you attribute it to the author, Cory Doctorow, and include a link to <a href="https://pluralistic.net">pluralistic.net</a>.
  <img src="https://i1.wp.com/craphound.com/images/by.svg.png?w=100&#038;ssl=1" data-recalc-dims="1"/>
  <br/>
  Quotations and images are not included in this license; they are included either under a limitation or exception to copyright, or on the basis of a separate license. Please exercise caution.
  <br/>
  <a href="http://pluralistic.net">Pluralistic Blog</a>
  <a href="https://pluralistic.net/plura-list">Newsletter</a>
  <a href="https://mamot.fr/web/accounts/303320">Mastodon</a>
  <a href="https://twitter.com/doctorow">Twitter</a>
  <a href="https://mostlysignssomeportents.tumblr.com/tagged/pluralistic">Tumblr</a>
  <a href="https://3bahu8v3r3.execute-api.us-east-1.amazonaws.com/default/pluralisticBiteSized">Pluralistic Bite Sized (this version)</a>
  <a href="https://github.com/mikeymckay/feed-rewriter">Source code for generating bite sized version</a>
</small>
      '
      feed.addItem getItem(contentItem)

getItem = (contentItem) =>
  dom = Cheerio.load(contentItem)
  url = null
  for link in dom('a')
    if link.children?[0]?.data is "permalink"
      url = link.attribs.href
      break
  title = dom('h1')
  return
    title: dom('h1').text().replace(/\(permalink\)/,"")
    description: contentItem
    url: url

exports.handler = (event) =>
  for item in (await parser.parseURL('https://pluralistic.net/feed/')).items
    splitItem(item)
  return
    statusCode: 200,
    body: feed.rss2()


