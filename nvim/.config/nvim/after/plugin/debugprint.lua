require('debugprint').setup(
  {
    filetypes = {
      ['php'] = {
        left = [[dump(']],
        right = [[');]],
        mid_var = [[', $]],
        right_var = [[);]],
      },
    },
  }
)
