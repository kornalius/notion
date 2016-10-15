app

  style.
    .uk-panel {
      background-color: #f7f7f7;
    }

  document(doc="{ doc }")

  script.
    this.doc = new Document('untitled', [
      new Cell('demo1', '**bold** text in markdown'),
      new Cell('demo2'),
      new Cell('demo3'),
      new Cell('demo4', '## Header\ntext in markdown'),
    ])
