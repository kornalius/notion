export default class Cell {

  constructor (name, markdown, code, children) {
    this.name = name
    this.markdown = { content: markdown || '' }
    this.code = code || []
    this.children = children || []
  }

}
