# 2D-Dispersion

This code contains three primary functionalities

- Generating datasets of possible metamaterial geometries.

- Calculating the dispersion curves and/or surfaces of the geometry datasets.

- Analyzing the bandgap characteristics of the dispersion datasets.

## Metamaterial Geometries

Inputs: number of geometries, number of pixels (usually 32x32), and parameters for random generation of designs (usually Gaussian kernel with given correlation length, variation, and symmetry).

Output: dataset of metamaterial geometries, generated according to the specified parameters.

## Dispersion Calculation

Inputs: number and path/grid for wavevectors, number of eigenvectors to calculate, and material properties (elastic modulus, density, poisson ratio).

Output: dataset of dispersion curves/surfaces for the metamaterial geometries.

## Analysis

Inputs: maximum bandgap width/location to consider, and bandgap width threshold for classification as bandgap.

Output: distribution of bandgap widths and locations for  the dataset, as well as success rate for bandgap existence in the dataset.