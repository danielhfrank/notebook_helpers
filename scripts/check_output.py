"""
usage: python check_output.py notebook.ipynb

exits with 0 if notebook clean, 1 otherwise
"""
import sys
import io
from IPython.nbformat import current


def check_outputs(nb):
    """check the outputs from a notebook"""
    return all(check_each_output(nb))

def check_each_output(nb):
    for ws in nb.worksheets:
        for cell in ws.cells:
            if cell.cell_type == 'code':
                yield cell.outputs == []

if __name__ == '__main__':
    fname = sys.argv[1]
    with io.open(fname, 'r') as f:
        nb = current.read(f, 'json')
    is_clean = check_outputs(nb)
    # silly unix with 0=true
    sys.exit(int(not is_clean))
