cell

  style.
    $primary-color: #333;

    .cell {
      &.uk-panel {
        margin: 16px;
      }

      &.uk-panel-box {
        padding: 0;
      }

      .content {
        min-height: 4em;
        padding: 8px;
      }
    }

    .paper-shadow {
      box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
    }

    .cell-title {
      padding: 8px;
      margin: 0;
      background-color: white;
      border-bottom: 2px solid #ddd;
      * {
        margin-bottom: 0;
      }
      .buttons a {
        margin: 0 4px;
        opacity: .7;
        line-height: inherit;
      }
    }

    .uk-panel-status-bar {
      background-color: #fbfbfb;
      border-top: 1px solid #ddd;
      height: 2em;
      * {
        color: #7f7f7f;
      }
    }

    .uk-panel-status-bar-section {
      padding: 0 8px;
      &:nth-child(even) {
        border-left: 1px solid #ddd;
        border-right: 1px solid #ddd;
      }
    }

    div.CodeMirror {
      font-family: monospace;
      min-height: 4em;
      height: 8em;
      .cm-matchhighlight {
        outline: 1px dotted rgba(175, 175, 175, 0.75);
        outline-offset: 2px;
      }
      .CodeMirror-selection-highlight-scrollbar {
        background-color: green;
      }
      .cm-trailingspace {
        border-bottom: 1px dotted red;
      }
      span.CodeMirror-matchingbracket {
        padding-bottom: 2px;
        color: #d44;
        border-bottom: 1px dotted;
      }
      .CodeMirror-cursor {
        width: auto;
        border: 0;
        background: rgba(0, 0, 0, 0.35);
        z-index: 1;
      }
    }


  .cell.uk-panel.uk-panel-box.uk-panel-hover.paper-shadow

    // Title bar
    .cell-title.uk-panel-title.uk-flex.uk-sortable-handle
      h3.uk-width  { name }
      .buttons.uk-align-right.uk-flex
        a.uk-icon-pencil.uk-icon-hover(href="#!")
        a.uk-icon-hover(class="{ view_mode == 'md' ? 'uk-icon-code' : 'uk-icon-hashtag' }" href="#!" ontap="{ toggle_code }")
        a.uk-icon-close.uk-icon-hover(href="#!")

    .content
      rg-markdown(show="{ view_mode == 'md' }" markdown="{ markdown }")
      #codemirror(show="{ view_mode == 'code' }")

    cell(each="{ children }")

    // Status bar
    .uk-panel-status-bar.uk-flex
      .uk-panel-status-bar-section.uk-width.uk-vertical-align
        .uk-vertical-align-middle 14.5ms
      .uk-panel-status-bar-section.uk-width.uk-vertical-align
        .uk-vertical-align-middle cell.js
      .uk-panel-status-bar-section.uk-width.uk-vertical-align
        .uk-vertical-align-middle More info...


  script.
    this.view_mode = 'md'

    this.toggle_code = e => {
      if (this.view_mode === 'md') {
        this.view_mode = 'code'
      }
      else {
        this.view_mode = 'md'
      }
    }

    this.on('mount', () => {
      this.editor = new CodeMirror(this.codemirror, {
        value: 'function myScript () { return 100; }\n',
        mode: 'javascript',
        theme: 'ttcn',
        scrollbarStyle: 'simple',
        tabSize: 2,
        lineWrapping: true,
        lineNumbers: true,
        foldGutter: true,
        gutters: [ 'CodeMirror-linenumbers', 'CodeMirror-foldgutter' ],
        matchBrackets: true,
        autoCloseBrackets: true,
        showCursorWhenSelecting: true,
        lineWiseCopyCut: true,
        dragDrop: false,
        styleActiveLine: true,
        highlightSelectionMatches: { showToken: false, annotateScrollbar: true },
        showTrailingSpace: true,
        keyMap: 'sublime',
        extraKeys: {
          'Ctrl-Q': cm => cm.foldCode(cm.getCursor()),
          'Ctrl-Space': 'autocomplete',
          'Shift-Enter': cm => {
            let curLine = cm.getCursor().line
            cm.replaceRange(cm.getLine(curLine) + '\n', { line: curLine, ch: 0 })
          },
          'Esc': (cm, e) => {
            let r = cm.execCommand('clearSearch')
            if (r === true) {
              return r
            }
            cm.execCommand('close')
          },
        },
      })
    })
