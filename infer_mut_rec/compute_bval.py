import math


def compute_bval(U, sh, rec):
    """
    This function computes B value using equation 8 of Hudson and Kaplan 1995) for one value of recombination rate
    :param U:
    :param sh:
    :param rec:
    :return:
    """
    bval = math.exp(-U/(2*sh+rec))
    return bval
