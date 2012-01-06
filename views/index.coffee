doctype 5
head ->
  css 'style'
  js 'scripts'
html ->
  title 'Test'
body ->
  h1 'Test'
  div id:'content', -> 'Hello World!'

