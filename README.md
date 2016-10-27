SimOutUtils - Utilities for analyzing time series simulation output
===================================================================

1\.  [What is SimOutUtils?](#whatissimoututils?)  
2\.  [File format](#fileformat)  
3\.  [How to use the utilities](#howtousetheutilities)  
4\.  [Examples](#examples)  
4.1\.  [Core functionality](#corefunctionality)  
4.1.1\.  [Plot simulation output](#plotsimulationoutput)  
4.1.2\.  [Get statistical summaries from one replication](#getstatisticalsummariesfromonereplication)  
4.1.3\.  [Get and analyze statistical summaries from multiple replications](#getandanalyzestatisticalsummariesfrommultiplereplications)  
4.2\.  [Distributional analysis of output](#distributionalanalysisofoutput)  
4.2.1\.  [Distributional analysis tables](#distributionalanalysistables)  
4.2.2\.  [Visually analyze the distributional properties of a focal measure](#visuallyanalyzethedistributionalpropertiesofafocalmeasure)  
4.2.3\.  [LaTeX table with distributional analysis of all focal measures for one setup](#latextablewithdistributionalanalysisofallfocalmeasuresforonesetup)  
4.2.4\.  [LaTeX table with a distributional analysis of one focal measure for multiple setups](#latextablewithadistributionalanalysisofonefocalmeasureformultiplesetups)  
4.3\.  [Comparison of model implementations](#comparisonofmodelimplementations)  
4.3.1\.  [Compare focal measures of two model implementations](#comparefocalmeasuresoftwomodelimplementations)  
4.3.2\.  [Compare focal measures of multiple model implementations](#comparefocalmeasuresofmultiplemodelimplementations)  
4.3.3\.  [Pairwise comparison of model implementations](#pairwisecomparisonofmodelimplementations)  
4.3.4\.  [Plot the PDF and CDF of focal measures from one or more model implementations](#plotthepdfandcdfoffocalmeasuresfromoneormoremodelimplementations)  
4.3.5\.  [Table with _p_-values from comparison of focal measures from model implementations](#tablewith_p_-valuesfromcomparisonoffocalmeasuresfrommodelimplementations)  
4.3.6\.  [Multiple comparisons and comparison names](#multiplecomparisonsandcomparisonnames)  
4.3.7\.  [Comparison groups](#comparisongroups)  
5\.  [Unit tests](#unittests)  
6\.  [License](#license)  
7\.  [References](#references)  

<a name="whatissimoututils?"></a>

## 1\. What is SimOutUtils?

A number of [MATLAB]/[Octave] functions for analyzing output data from
simulation models, as well as for producing publication quality tables and
figures. These utilities were originally developed to analyze the [PPHPC] model,
and later generalized to be usable with stochastic simulation models with time
series-like outputs.

These utilities are compatible with GNU Octave. However, note that a number of 
statistical tests provided by Octave return slightly different _p_-values from
those returned by the equivalent MATLAB functions.

The following links list the available functions:

* [Core functions](core)
* [Distributional analysis of output](dist)
* [Comparison of model implementations](compare)
* [Helper functions](helpers)
* [Third-party functions](3rdparty)

If you use _SimOutUtils_, please cite reference [\[1\]][ref1].

<a name="fileformat"></a>

## 2\. File format

The functions provided by _SimOutUtils_ use the [dlmread] MATLAB/Octave function
to open files containing simulation output. As such, these functions expect text
files with numeric values delimited by a separator (automatically inferred by
[dlmread]). The files should contain data values in tabular format, with one
column per output and one row per iteration.

<a name="howtousetheutilities"></a>

## 3\. How to use the utilities

Clone or download the utilities to any folder. Then, either start 
[MATLAB]/[Octave] directly in this folder, or `cd` into this folder and execute
the [startup] script:

```
startup
```

<a name="examples"></a>

## 4\. Examples

The examples use the following datasets:

1. [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.34053.svg)](http://dx.doi.org/10.5281/zenodo.34053)
2. [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.34049.svg)](http://dx.doi.org/10.5281/zenodo.34049)
3. [![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.46848.svg)](http://dx.doi.org/10.5281/zenodo.46848)

These datasets correspond to the results presented in references [\[2\]][ref2],
[\[3\]][ref3] and [\[4\]][ref4], respectively.

Unpack the datasets to any folder and put the complete path to these folders in
variables `datafolder1`, `datafolder2` and `datafolder3`, respectively:

```matlab
datafolder1 = 'path/to/dataset1';
datafolder2 = 'path/to/dataset2';
datafolder3 = 'path/to/dataset3';
```

The datasets contain output from several implementations of the [PPHPC]
agent-based model. [PPHPC] is a realization of prototypical predator-prey
system with six outputs: 

1. Sheep population
2. Wolves population
3. Quantity of available grass
4. Mean sheep energy
5. Mean wolves energy
6. Mean value of the grass countdown parameter

Dataset 1 contains output from the [NetLogo] implementation of [PPHPC]. It is
used in the [core functionality](#corefunctionality) and
[distributional analysis of output](#distributionalanalysisofoutput) examples.
Dataset 2 contains output from the NetLogo implementation and from six variants
of a parallel Java implementation, namely, ST, EQ, EX, ER and OD. These
implementations and variants are *aligned*, i.e., they display the same dynamic
behavior. Finally, dataset 3 contains aligned output from the NetLogo and Java
EX implementations, and also output from two purposefully misaligned versions of
the latter. Datasets 2 and 3 are used in the examples concerning the
[comparison of model implementations](#comparisonofmodelimplementations).

The datasets were collected under five different model sizes (100 _x_ 100,
200 _x_ 200, 400 _x_ 400, 800 _x_ 800 and 1600 _x_ 1600) and two distinct
parameterizations (_v1_ and _v2_).

<a name="corefunctionality"></a>

### 4.1\. Core functionality

<a name="plotsimulationoutput"></a>

#### 4.1.1\. Plot simulation output

Use the [output_plot] function to plot outputs from one replication of the PPHPC
model:

```matlab
output_plot([datafolder1 '/v1'], 'stats100v1r1.txt', 6);
```

![simout_ex01_01](https://cloud.githubusercontent.com/assets/3018963/11877081/0209605a-a4e5-11e5-8092-95dfe0bbcd5b.png)

The third parameter specifies the number of outputs. Alternatively, a cell array
of strings can be passed in order to display personalized output names.
Furthermore, outputs 4 to 6 are practically not visible, as they have a very
different scale from outputs 1 to 3. The 'layout' option defines how many
outputs to plot per figure, and can be used to solve this problem. As such,
[output_plot] can be invoked in the following way:

```matlab
outputs = {'SheepPop', 'WolfPop', 'GrassQty', 'SheepEnergy', 'WolfEnergy', 'GrassEnergy'};
output_plot([datafolder1 '/v1'], 'stats100v1r1.txt', outputs, 'layout', [3 3]);
```

![simout_ex01_02](https://cloud.githubusercontent.com/assets/3018963/11877082/02217ffa-a4e5-11e5-9729-ed5678443c96.png)
![simout_ex01_021](https://cloud.githubusercontent.com/assets/3018963/12080034/8eabfcf8-b245-11e5-9c28-ad4fc1bbf2fe.png)

The 'layout' option is one of the several key-value arguments accepted by
[output_plot]. Another option is the 'Colors' parameter, which specifies the
colors used for plotting individual outputs. It can be used, for example, to use
the same colors for the outputs in both figures:

```matlab
output_plot([datafolder1 '/v1'], 'stats100v1r1.txt', outputs, 'layout', [3 3], 'Colors', {'b', 'r', 'g', 'b', 'r', 'g'});
```

![simout_ex01_02](https://cloud.githubusercontent.com/assets/3018963/11877082/02217ffa-a4e5-11e5-9729-ed5678443c96.png)
![simout_ex01_03](https://cloud.githubusercontent.com/assets/3018963/11877083/0230e2a6-a4e5-11e5-884f-fc6140e258af.png)

A number of these key-value arguments consist of [LineSpec]s for individual
outputs ([PatchSpec]s in the case of type **f** plots, discussed further ahead).
If there are more outputs than specs in the associated cell array, the given
specs are repeated. As such, in the previous command we could have shortened the
given 'Colors' cell array, i.e.:

```matlab
output_plot([datafolder1 '/v1'], 'stats100v1r1.txt', outputs, 'layout', [3 3], 'Colors', {'b', 'r', 'g'});
```

The [output_plot] function recognizes a number of [LineSpec]s and [PatchSpec]s,
namely 'Colors', 'LineStyles', 'LineWidths', 'Markers', 'MarkerEdgeColors',
'MarkerFaceColors' and 'MarkerSizes'. There is also the 'EdgeColors' option,
which is only recognized within the [PatchSpec]s context, i.e. for type **f**
plots.

Returning to the example, the third and sixth outputs of the last command
(*GrassQty* and *GrassEnergy*, respectively) are still somewhat out of scale
with the remaining outputs. This can be solved by specifying the 'scale' option:

```matlab
outputs = {'SheepPop', 'WolfPop', 'GrassQty/4', 'SheepEnergy', 'WolfEnergy', '4*GrassEnergy'};
output_plot([datafolder1 '/v1'], 'stats100v1r1.txt', outputs, 'layout', [3 3], 'Colors', {'b', 'r', 'g'}, 'scale', [1 1 1/4 1 1 4]);
```

![simout_ex01_04](https://cloud.githubusercontent.com/assets/3018963/11877084/02356862-a4e5-11e5-8c79-06a85fda0a67.png)
![simout_ex01_05](https://cloud.githubusercontent.com/assets/3018963/11877085/023607ea-a4e5-11e5-83e2-8807d9927253.png)

The plot looks good now. In order to plot outputs from multiple replications, we
simply use wildcards to load more than one file:

```matlab
output_plot([datafolder1 '/v1'], 'stats100v1r*.txt', outputs, 'layout', [3 3], 'Colors', {'b', 'r', 'g'}, 'scale', [1 1 1/4 1 1 4]);
```

![simout_ex01_06](https://cloud.githubusercontent.com/assets/3018963/11877088/023508a4-a4e5-11e5-91d0-1cc2274a3537.png)
![simout_ex01_07](https://cloud.githubusercontent.com/assets/3018963/11877086/02362194-a4e5-11e5-889d-95f82bd69fac.png)

When plotting multiple replications this way, the figures tend to look somewhat
heavy and are slow to manipulate. We could alternatively plot only the output
extremes (minimum and maximum of individual outputs at each iteration), and fill
the space between with the output color. This can be accomplished by specifying
the **f**ill 'type':

```matlab
output_plot([datafolder1 '/v1'], 'stats100v1r*.txt', outputs, 'type', 'f', 'layout', [3 3], 'Colors', {'b', 'r', 'g'}, 'scale', [1 1 1/4 1 1 4]);
```

![simout_ex01_08](https://cloud.githubusercontent.com/assets/3018963/11877087/0238c8b8-a4e5-11e5-9663-bf792e8a289e.png)
![simout_ex01_09](https://cloud.githubusercontent.com/assets/3018963/11877089/0247e3b6-a4e5-11e5-9be5-aa0b073e185d.png)

Finally, it is also possible to visualize the moving average of each output over
multiple replications by passing a positive integer as the 'type' option. This 
positive integer is the window size with which to smooth the output. A value of 
zero is equivalent to no smoothing, i.e. the function will simply plot the 
averaged outputs. A value of 10 offers a good balance between rough and overly 
smooth plots:

```matlab
output_plot([datafolder1 '/v1'], 'stats100v1r*.txt', outputs, 'type', 10, 'layout', [3 3], 'Colors', {'b', 'r', 'g'}, 'scale', [1 1 1/4 1 1 4]);
```

![simout_ex01_10](https://cloud.githubusercontent.com/assets/3018963/11877090/024d2362-a4e5-11e5-908f-533e5dca8d8a.png)
![simout_ex01_11](https://cloud.githubusercontent.com/assets/3018963/11877091/025138f8-a4e5-11e5-88fb-ffa524459581.png)

The moving average type of plot is useful for empirically selecting a 
steady-state truncation point.

The following command plots only the first 3 outputs in black color, with
different line styles:

```matlab
output_plot([datafolder1 '/v1'], 'stats100v1r*.txt', outputs(1:3), 'type', 10, 'Colors', 'k', 'scale', [1 1 1/4], 'LineStyles', {'-','--',':'});
```

![simout_ex01_12](https://cloud.githubusercontent.com/assets/3018963/12080126/2982dee2-b249-11e5-8b0a-a55230d2f32a.png)


Figures generated with [output_plot] can be converted to LaTeX with the
excellent [matlab2tikz] script. For the previous figure, the following commands
would perform this conversion, assuming [matlab2tikz] is in [MATLAB]'s path:

```matlab
cleanfigure();
matlab2tikz('standalone', true, 'filename', 'simout_bw.tex');
```

Compiling the `simout_bw.tex` file with LaTeX would produce the following
figure:

![simout_ex01_13](https://cloud.githubusercontent.com/assets/3018963/12067963/73c55840-affb-11e5-840a-74c18d3cad30.png)

<a name="getstatisticalsummariesfromonereplication"></a>

#### 4.1.2\. Get statistical summaries from one replication

The [stats_get] function is the elementary building block of _SimOutUtils_ for
analyzing simulation output. It is indirectly used by most package functions
(via the higher-level [stats_gather] function). The goal of [stats_get] is to
extract statistical summaries from simulation outputs from one file. It does
this through ancillary `stats_get_*` functions which perform the actual
extraction. The exact function to use (and consequently, the concrete
statistical summaries to extract) is specified in the `simoututils_stats_get_`
global variable, defined in the [startup] script when _SimOutUtils_ is loaded.

The [stats_get_pphpc] function is the package default. This function returns six
statistical summaries, namely the maximum (**max**), iteration where maximum
occurs (**argmax**), minimum (**min**), iteration where minimum occurs
(**argmin**), mean (**mean**), and standard deviation (**std**). The **mean**
and **std** summaries are obtained during the (user-specified) steady-state
stage of the output. These summaries were selected for the PPHPC model
[\[2\]][ref2], but are appropriate for any model with tendentiously stable
time series outputs.

The following instruction gets the statistical summaries of the first
replication of the PPHPC model for size 100 and parameter set 1:

```matlab
sdata = stats_get(1000, [datafolder1 '/v1/stats100v1r1.txt'], 6)
```

The first argument is dependent on the actual `stats_get_*` being used. In this
case, we are using the package default [stats_get_pphpc] function, which
requires the user to specify the steady-state truncation point (i.e., 1000). The
last argument specifies the number of outputs. The function returns a _n_ x _m_
matrix of focal measures, with _n_=6 statistical summaries and _m_=6 outputs:

```
sdata =

   1.0e+03 *

    2.5160    0.5260    8.6390    0.0190    0.0331    0.0035
    0.1530    3.3130    0.0120    0.0690    0.2550    0.1590
    0.3050    0.0180    3.6530    0.0045    0.0122    0.0007
    0.0070    0.0860    0.1590         0    0.0150    0.0100
    1.1854    0.3880    6.2211    0.0164    0.0244    0.0021
    0.1211    0.0487    0.2731    0.0007    0.0016    0.0002
```

In order to use alternative statistical summaries, the user should specify
another function by setting the appropriate function handle in the
`simoututils_stats_get_` global variable:

```matlab
simoututils_stats_get_ = @stats_get_iters;
```

The previous instruction configures [stats_get_iters] as the `stats_get_*`
function to use. The statistical summaries fetched by this function are simply
the output values at user-specified iterations. Invoking [stats_get] again, the
first argument now specifies the iterations at which to get output values:

```matlab
sdata = stats_get([10 100 1000], [datafolder1 '/v1/stats100v1r1.txt'], 6)
```

The returned _n_ x _m_ matrix of focal measure now has _n_=3 statistical 
summaries and _m_=6 outputs:

```
sdata =

   1.0e+03 *

    0.3180    0.2160    8.5940    0.0115    0.0139    0.0007
    1.9110    0.0240    4.9280    0.0160    0.0246    0.0028
    1.0060    0.4690    6.6110    0.0170    0.0207    0.0018
```

To permanently use another `stats_get_*` function as default, edit the [startup]
script and change the value of the `simoututils_stats_get_` global variable as
desired. For the remainder of this discussion it is assumed that the
[stats_get_pphpc] function is being used.

<a name="getandanalyzestatisticalsummariesfrommultiplereplications"></a>

#### 4.1.3\. Get and analyze statistical summaries from multiple replications

The [stats_gather] function extracts statistical summaries from simulation
outputs from multiple files. The following instruction obtains statistical
summaries for 30 runs of the PPHPC model for size 100 and parameter set 1:

```matlab
s100v1 = stats_gather('100v1', [datafolder1 '/v1'], 'stats100v1r*.txt', 6, 1000);
```

The fourth parameter, 6, corresponds to the number of outputs of the PPHPC
model. Instead of the number of outputs, the function alternatively accepts a
cell array of strings containing the output names, which can be useful for
tables and figures. The fifth and last parameter, 1000 , corresponds to the
iteration after which the outputs are in steady-state. The [stats_gather]
function returns a _struct_ with several fields, of which the following are
important to this discussion:

* `name` contains the name with which the data was tagged, '100v1' in this case;
* `outputs` is a cell array containing the output names (which default to 'o1', 
'o2', etc.); 
* `sdata` is a 30 x 36 matrix, with 30 observations (from 30 files) and 36 focal
measures (six statistical summaries for each of the six outputs).

Next, we analyze the focal measures (i.e., statistical summaries for each
output):

```matlab
[m, v, cit, ciw, sw, sk] = stats_analyze(s100v1.sdata', 0.05);
```

The 0.05 value in the second parameter is the significance level for the
confidence intervals and the Shapiro-Wilk test. The variables returned by the 
[stats_analyze] function have 36 rows, one per focal measure. The `m` (mean),
`v` (variance), `sw` (_p_-value of the Shapiro-Wilk test) and `sk` (skewness)
variables have only one column, i.e. one value per focal measure, while the
`cit` (_t_-confidence interval) and `ciw` (Willink confidence interval
[\[5\]][ref5]) variables have two columns, which correspond to the lower and
upper limits of the respective intervals.

<a name="distributionalanalysisofoutput"></a>

### 4.2\. Distributional analysis of output

<a name="distributionalanalysistables"></a>

#### 4.2.1\. Distributional analysis tables

While the data returned by the [stats_analyze] is in a format adequate for
further processing and/or analysis, it is not very human readable. For this
purpose, we can use the [stats_table_per_setup] function to output an
informative plain text table:

```matlab
stats_table_per_setup(s100v1, 0.05, 0)
```

```
-----------------------------------------------------------------------------------------
|   Output   | Stat.    |    Mean    |  Variance  |    95.0% Conf. interval   | SW test |
|------------|----------|------------|------------|---------------------------|---------|
|         o1 |      max |       2517 |       6699 | [       2486,       2547] |  0.8287 |
|            |   argmax |      145.2 |      91.36 | [      141.7,      148.8] |  0.8255 |
|            |      min |        317 |      204.9 | [      311.7,      322.3] |  0.8227 |
|            |   argmin |        6.8 |       6.51 | [      5.847,      7.753] |  0.0326 |
|            |     mean |       1186 |      65.54 | [       1183,       1189] |  0.9663 |
|            |      std |      107.9 |      223.9 | [      102.3,      113.5] |  0.3534 |
|------------|----------|------------|------------|---------------------------|---------|
|         o2 |      max |      530.5 |      435.8 | [      522.7,      538.3] |  0.0026 |
|            |   argmax |       2058 |  8.845e+05 | [       1707,       2409] |  0.1654 |
|            |      min |       19.9 |      58.58 | [      17.04,      22.76] |  0.6423 |
|            |   argmin |      71.93 |      105.7 | [       68.1,      75.77] |  0.1912 |
|            |     mean |      390.5 |      6.518 | [      389.5,      391.4] |  0.1380 |
|            |      std |      44.93 |       25.6 | [      43.04,      46.82] |  0.0737 |
|------------|----------|------------|------------|---------------------------|---------|
|         o3 |      max |       8624 |       4097 | [       8600,       8647] |  0.3778 |
|            |   argmax |       11.7 |     0.2862 | [       11.5,       11.9] |  0.0000 |
|            |      min |       3745 |   1.66e+04 | [       3697,       3793] |  0.5270 |
|            |   argmin |      148.2 |      94.14 | [      144.5,      151.8] |  0.6463 |
|            |     mean |       6216 |      285.7 | [       6210,       6222] |  0.6502 |
|            |      std |      247.3 |       1128 | [      234.7,      259.8] |  0.0824 |
|------------|----------|------------|------------|---------------------------|---------|
|         o4 |      max |      19.74 |     0.5092 | [      19.47,         20] |  0.1594 |
|            |   argmax |      53.07 |      36.96 | [       50.8,      55.34] |  0.3321 |
|            |      min |      4.461 |    0.01765 | [      4.412,      4.511] |  0.9519 |
|            |   argmin |          0 |          0 | [          0,          0] |    NaN |
|            |     mean |      16.38 |   0.003763 | [      16.36,      16.41] |  0.9614 |
|            |      std |      0.653 |   0.004133 | [      0.629,      0.677] |  0.4578 |
|------------|----------|------------|------------|---------------------------|---------|
|         o5 |      max |      41.86 |      41.39 | [      39.46,      44.26] |  0.0761 |
|            |   argmax |      135.7 |       1075 | [      123.4,      147.9] |  0.0021 |
|            |      min |      11.31 |     0.9338 | [      10.95,      11.67] |  0.1280 |
|            |   argmin |      24.33 |      142.7 | [      19.87,      28.79] |  0.0000 |
|            |     mean |      24.61 |    0.02589 | [      24.55,      24.67] |  0.6280 |
|            |      std |      1.673 |    0.01815 | [      1.623,      1.723] |  0.0457 |
|------------|----------|------------|------------|---------------------------|---------|
|         o6 |      max |      3.455 |   0.005314 | [      3.428,      3.482] |  0.5257 |
|            |   argmax |      148.9 |      109.8 | [        145,      152.8] |  0.5714 |
|            |      min |     0.7595 |   0.001429 | [     0.7454,     0.7736] |  0.2921 |
|            |   argmin |      10.33 |     0.2989 | [      10.13,      10.54] |  0.0000 |
|            |     mean |      2.081 |  8.627e-05 | [      2.078,      2.085] |  0.6190 |
|            |      std |     0.1371 |  0.0003382 | [     0.1302,      0.144] |  0.0794 |
-----------------------------------------------------------------------------------------
```

The last parameter, 0, specifies plain text output. This function can also 
output a publication quality LaTeX table by setting the last argument to 1:

```matlab
stats_table_per_setup(s100v1, 0.05, 1)
```

![simout_ex03](https://cloud.githubusercontent.com/assets/3018963/11901414/689d8b34-a5a3-11e5-803a-e5fc0688d09d.png)

The produced LaTeX table requires the [siunitx], [multirow], [booktabs] and
[ulem] packages to compile.

<a name="visuallyanalyzethedistributionalpropertiesofafocalmeasure"></a>

#### 4.2.2\. Visually analyze the distributional properties of a focal measure

The [dist_plot_per_fm] function offers a simple way of assessing the
distributional properties of a focal measure for different model configurations
(i.e., different model sizes, different parameter set, etc). For each
configuration the function shows an approximate probability density function
(PDF), a histogram, and a QQ-plot. The [dist_plot_per_fm] function works with
the data returned by [stats_gather].

For example, let us assess the distributional properties of the PPHPC focal
measure given by the **argmin** of the _grass quantity_ output for parameter set
2 and a number of different model sizes:

```matlab
% Get statistical summaries for different model sizes, parameter set 2
outputs = {'SheepPop', 'WolfPop', 'GrassQty', 'SheepEn', 'WolfEn', 'GrassEn'};
s100v2 = stats_gather('100v2', [datafolder1 '/v2'], 'stats100v2r*.txt', outputs, 2000);
s200v2 = stats_gather('200v2', [datafolder1 '/v2'], 'stats200v2r*.txt', outputs, 2000);
s400v2 = stats_gather('400v2', [datafolder1 '/v2'], 'stats400v2r*.txt', outputs, 2000);
s800v2 = stats_gather('800v2', [datafolder1 '/v2'], 'stats800v2r*.txt', outputs, 2000);
s1600v2 = stats_gather('1600v2', [datafolder1 '/v2'], 'stats1600v2r*.txt', outputs, 2000);

% Group them into a cell array
sv2 = {s100v2, s200v2, s400v2, s800v2, s1600v2};
```

The **argmin** of the *grass quantity* output is the third statistical summary
of the fourth output, as indicated in the second and third arguments of
[dist_plot_per_fm]:

```matlab
% Plot distributional properties
dist_plot_per_fm(sv2, 3, 4);
```

![simout_ex04](https://cloud.githubusercontent.com/assets/3018963/12080546/07401900-b256-11e5-8bfc-e868ce1f53b8.png)

Note that in this example we explicitly specified the output names when calling
the [stats_gather] function. Also, for parameter set 2, we set the steady-state
truncation point to iteration 2000.

<a name="latextablewithdistributionalanalysisofallfocalmeasuresforonesetup"></a>

#### 4.2.3\. LaTeX table with distributional analysis of all focal measures for one setup

In reference [\[2\]][ref2], a number of [tables][ref2tables] containing a
detailed distributional analysis of all PPHPC focal measures are provided as
supplemental information. Each table displays a distributional analysis for one
setup, i.e., for one size/parameter set combination. The [dist_table_per_setup]
function produces these tables, accepting a single parameter which corresponds
to the output of [stats_gather]. For example, to get a table with the
distributional analysis of all PPHPC focal measures for model size 1600,
parameter set 2, only two commands are required:

```matlab
outputs = {'$P^s_i$', '$P^w_i$', '$P^c_i$', '$\bar{E}^s_i$', '$\bar{E}^w_i$', '$\bar{C}_i$'};
s1600v2 = stats_gather('1600v2', [datafolder1 '/v2'], 'stats1600v2r*.txt', outputs, 2000);
dist_table_per_setup(s1600v2)
```

![simout_ex05](https://cloud.githubusercontent.com/assets/3018963/11902078/432d565a-a5a7-11e5-877f-9e1fe65bfc62.png)

We specify the output names in LaTeX math mode so they appear in the produced
table as they appear in the article.

<a name="latextablewithadistributionalanalysisofonefocalmeasureformultiplesetups"></a>

#### 4.2.4\. LaTeX table with a distributional analysis of one focal measure for multiple setups

A distributional analysis of a focal measure for multiple setups is often useful
for evaluating how its distributional properties vary with different model
configurations/setups. The [dist_table_per_fm] function fits this purpose.
However, this function returns a partial table, which can have additional
columns (specified with the 'pre' parameter) prior to the distributional data
itself, as well as additional rows, such as headers, footers, similar partial
tables for other focal measures, and so on.

Using the PPHPC model as an example, let us generate a table with the
distributional analysis of the steady-state **mean** of the *sheep population*,
for all tested model sizes and both parameter sets. Model sizes are specified as
columns, while parameter sets are obtained with two separate partial tables,
which together form the final table:

```matlab
% Get stats data for parameter set 1, all sizes
s100v1 = stats_gather('100v1', [datafolder1 '/v1'], 'stats100v1r*.txt', outputs, 1000);
s200v1 = stats_gather('200v1', [datafolder1 '/v1'], 'stats200v1r*.txt', outputs, 1000);
s400v1 = stats_gather('400v1', [datafolder1 '/v1'], 'stats400v1r*.txt', outputs, 1000);
s800v1 = stats_gather('800v1', [datafolder1 '/v1'], 'stats800v1r*.txt', outputs, 1000);
s1600v1 = stats_gather('1600v1', [datafolder1 '/v1'], 'stats1600v1r*.txt', outputs, 1000);
datas1 = {s100v1, s200v1, s400v1, s800v1, s1600v1};

% Get stats data for parameter set 2, all sizes
s100v2 = stats_gather('100v2', [datafolder1 '/v2'], 'stats100v2r*.txt', outputs, 2000);
s200v2 = stats_gather('200v2', [datafolder1 '/v2'], 'stats200v2r*.txt', outputs, 2000);
s400v2 = stats_gather('400v2', [datafolder1 '/v2'], 'stats400v2r*.txt', outputs, 2000);
s800v2 = stats_gather('800v2', [datafolder1 '/v2'], 'stats800v2r*.txt', outputs, 2000);
s1600v2 = stats_gather('1600v2', [datafolder1 '/v2'], 'stats1600v2r*.txt', outputs, 2000);
datas2 = {s100v2, s200v2, s400v2, s800v2, s1600v2};

% Specify the focal measure: steady-state mean of the sheep population
out = 1;   % Sheep population
ssumm = 5; % Steady-state mean

% Table headers
t = sprintf('\n\\begin{table}[ht]');
t = sprintf('%s\n\\centering', t);
t = sprintf('%s\\begin{tabular}{ccrrrrrr}\n', t);
t = sprintf('%s\\toprule\n', t);
t = sprintf('%sSet & Stat. & 100 & 200 & 400 & 800 & 1600\\\\\n', t);
t = sprintf('%s\\midrule\n\\multirow{4}{*}{v1} ', t);

% First partial table, for parameter set 1
t = sprintf('%s%s', t, dist_table_per_fm(datas1, out, ssumm, 1));

% A midrule to separate the partial tables
t = sprintf('%s\\midrule\n\\multirow{4}{*}{v2}', t);

% Second partial table, for parameter set 2
t = sprintf('%s%s', t, dist_table_per_fm(datas2, out, ssumm, 1));

% Table footers and caption
t = sprintf('%s\\bottomrule\n', t);
t = sprintf('%s\n\\end{tabular}', t);
t = sprintf('%s\n\\caption{Distributional analysis of sheep population steady-state mean for different model sizes and parameter sets.}\n', t);
t = sprintf('%s\n\\end{table}\n', t);

% Show the table
t
```

![simout_ex06](https://cloud.githubusercontent.com/assets/3018963/11902170/d16d1e46-a5a7-11e5-82a7-f97f74a2982a.png)

<a name="comparisonofmodelimplementations"></a>

### 4.3\. Comparison of model implementations

<a name="comparefocalmeasuresoftwomodelimplementations"></a>

#### 4.3.1\. Compare focal measures of two model implementations

The [stats_compare] function is used for comparing focal measures from two or
more model implementations. For this purpose, it applies statistical tests to
data obtained with the [stats_gather] function.

In this example we compare the NetLogo and Java EX implementations of the PPHPC
model for model size 400, parameter set 1 (as described in reference
[\[3\]][ref3]). Replications of the Java EX variant were performed with 12
threads. First, we need to obtain the focal measures (i.e., statistical
summaries of simulation outputs) with the [stats_gather] function:

```matlab
% Get stats data for NetLogo implementation, parameter set 1, all sizes
snl400v1 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats400v1r*.txt', 6, 1000);

% Get stats data for the Java implementation, EX strategy (12 threads), parameter set 1, all sizes
sjex400v1 = stats_gather('JEX', [datafolder2 '/simout/EX'], 'stats400v1pEXt12r*.txt', 6, 1000);
```

The fourth parameter, 6, corresponds to the number of model outputs, while the
last, 1000, is the steady-state truncation point. We can now perform the
comparison using the [stats_compare] function:

```matlab
% Perform comparison
[ps, h_all] = stats_compare(0.01, {'p', 'np', 'p', 'np', 'p', 'p'}, 'none', snl400v1, sjex400v1)
```

The first parameter specifies the significance level for the statistical tests.
The second parameter specifies the tests to apply on individual statistical
summaries for each output. In this case we are performing the _t_-test to all
summaries, except **argmax** and **argmin**, to which the Mann-Whitney test
[\[6\]][ref6] is applied instead. The options 'p' and 'np' stand for parametric
and non-parametric, respectively. The third parameter specifies the _p_-value
adjustment method for comparing multiple focal measures. No correction is
performed in this case.

The [stats_compare] function return `ps`, a matrix of _p_-values for the
requested tests (rows correspond to outputs, columns to statistical summaries),
and `h_all`, containing the number of tests failed for the specified
significance level.

```
ps =

    0.1784    0.8491    0.4536    1.0000    0.9560    0.1666
    0.0991    0.4727    0.5335    0.0752    0.7231    0.1859
    0.2515    0.3006    0.2312    0.0852    0.8890    0.1683
    0.4685    0.8496    0.9354    1.0000    0.8421    0.4394
    0.7973    0.8796    0.0009    0.3534    0.2200    0.5757
    0.2443    0.0750    0.1719    1.0000    0.9009    0.1680


h_all =

     1
```

<a name="comparefocalmeasuresofmultiplemodelimplementations"></a>

#### 4.3.2\. Compare focal measures of multiple model implementations

The [stats_compare] function also allows to compare focal measure from more than
two model implementations. If more than two [stats_gather] structs are passed as
arguments, the [stats_compare] function automatically uses _n_-sample
statistical tests, namely ANOVA [\[7\]][ref7] as a parametric test, and
Kruskal-Wallis [\[8\]][ref8] as a non-parametric test. In the following, we
compare all Java variants of the PPHPC model for size 800, parameter set 2:

```matlab
% Get stats data for Java implementation, ST strategy
sjst800v2 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats800v2pSTr*.txt', 6, 2000);

% Get stats data for the Java implementation, EQ strategy (12 threads)
sjeq800v2 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats800v2pEQt12r*.txt', 6, 2000);

% Get stats data for the Java implementation, EX strategy (12 threads)
sjex800v2 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats800v2pEXt12r*.txt', 6, 2000);

% Get stats data for the Java implementation, ER strategy (12 threads)
sjer800v2 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats800v2pERt12r*.txt', 6, 2000);

% Get stats data for the Java implementation, OD strategy (12 threads, b = 500)
sjod800v2 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats800v2pODb500t12r*.txt', 6, 2000);

% Perform comparison
ps = stats_compare(0.05, {'p', 'np', 'p', 'np', 'p', 'p'}, 'none', sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2)
```

```
ps =

    0.8735    0.5325    1.0000    1.0000    0.7132    0.7257
    0.4476    0.9051    0.3624    0.5947    0.7011    0.6554
    0.4227    0.6240    0.8860    0.2442    0.5945    0.6785
    0.0124    0.5474    0.6447    0.5238    0.7038    0.6182
    0.8888    0.9622    0.1410    0.1900    0.7182    0.6825
    0.9306    0.6286    0.4479    0.8377    0.5785    0.6785
```

<a name="pairwisecomparisonofmodelimplementations"></a>

#### 4.3.3\. Pairwise comparison of model implementations

When comparing multiple model implementations, if one or more are misaligned, 
the [stats_compare] function will detected a misalignment, but will not provide
information regarding which implementations are misaligned. The
[stats_compare_pw] function performs pairwise comparisons of multiple model
implementations and outputs a table of failed tests for each pair of
implementations, allowing to detect which ones are misaligned. The following
instruction outputs this table for the data used in the previous example:

```matlab
% Output table of pairwise failed tests for significance level 0.05
stats_compare_pw(0.05, {'p', 'np', 'p', 'np', 'p', 'p'}, 'none', sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2)
```

```
             -----------------------------------------------------------------------
             |          ST |          EQ |          EX |          ER |          OD |
------------------------------------------------------------------------------------
|         ST |           0 |           1 |           1 |           1 |           2 |
|         EQ |           1 |           0 |           0 |           0 |           1 |
|         EX |           1 |           0 |           0 |           0 |           0 |
|         ER |           1 |           0 |           0 |           0 |           1 |
|         OD |           2 |           1 |           0 |           1 |           0 |
------------------------------------------------------------------------------------
```

Since each pairwise comparison involves the comparison of multiple focal
measures, it can be useful to correct the _p_-values to account for multiple
comparisons, e.g., using the [Bonferroni] procedure:

```matlab
% Output table of pairwise failed tests for significance level 0.05 with Bonferroni correction
stats_compare_pw(0.05, {'p', 'np', 'p', 'np', 'p', 'p'}, 'bonferroni', sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2)
```

```
             -----------------------------------------------------------------------
             |          ST |          EQ |          EX |          ER |          OD |
------------------------------------------------------------------------------------
|         ST |           0 |           0 |           0 |           0 |           0 |
|         EQ |           0 |           0 |           0 |           0 |           0 |
|         EX |           0 |           0 |           0 |           0 |           0 |
|         ER |           0 |           0 |           0 |           0 |           0 |
|         OD |           0 |           0 |           0 |           0 |           0 |
------------------------------------------------------------------------------------
```

No single test fails after the Bonferroni correction is applied to the
_p_-values, strengthening the conclusion that the compared model implementations
are aligned.

<a name="plotthepdfandcdfoffocalmeasuresfromoneormoremodelimplementations"></a>

#### 4.3.4\. Plot the PDF and CDF of focal measures from one or more model implementations

In this example we have two PPHPC implementations which produce equivalent
results (NLOK and JEXOK), and two other which display slightly different
behavior (JEXNS and JEXDIFF), as discussed in reference [\[4\]][ref4]. The
following code loads simulation output data from these four implementations, and
plots, using the [stats_compare_plot] function, the PDF and CDF of the
respective focal measures. Plots for each focal measure are overlaid, allowing
the modeler to observe distributional output differences between the various
implementations.

```matlab
% Specify output names
outputs = {'SheepPop', 'WolfPop', 'GrassQty', 'SheepEnergy', 'WolfEnergy', 'GrassEnergy'};

% Determine focal measures of four PPHPC implementations
snl800v2 = stats_gather('NL', [datafolder3 '/nl_ok'], 'stats800v2*.txt', outputs, 2000);
sjexok800v2 = stats_gather('JEXOK', [datafolder3 '/j_ex_ok'], 'stats800v2*.txt', outputs, 2000);
sjexns800v2 = stats_gather('JEXNS', [datafolder3 '/j_ex_noshuff'], 'stats800v2*.txt', outputs, 2000);
sjexdiff800v2 = stats_gather('JEXDIFF', [datafolder3 '/j_ex_diff'], 'stats800v2*.txt', outputs, 2000);

% Plot PDF and CDF of focal measures
stats_compare_plot(snl800v2, sjexok800v2, sjexns800v2, sjexdiff800v2);
```

_Sheep population_
![compare_ex04_01](https://cloud.githubusercontent.com/assets/3018963/11904411/d91d552e-a5b7-11e5-8cb2-fcaa8687291d.png)

_Wolf population_
![compare_ex04_02](https://cloud.githubusercontent.com/assets/3018963/11904410/d9180984-a5b7-11e5-9cf2-15d8eeb50a3a.png)

_Quantity of available grass_
![compare_ex04_03](https://cloud.githubusercontent.com/assets/3018963/11904409/d915f0fe-a5b7-11e5-87d8-0577c57265bf.png)

_Mean sheep energy_
![compare_ex04_04](https://cloud.githubusercontent.com/assets/3018963/11904408/d9155f18-a5b7-11e5-9570-95488f6f7642.png)

_Mean wolves energy_
![compare_ex04_05](https://cloud.githubusercontent.com/assets/3018963/11904406/d914c22e-a5b7-11e5-9de4-4226eb2789e4.png)

_Mean value of the countdown parameter in all cells_
![compare_ex04_06](https://cloud.githubusercontent.com/assets/3018963/11904407/d915052c-a5b7-11e5-927a-f8fdc73ac497.png)

<a name="tablewith_p_-valuesfromcomparisonoffocalmeasuresfrommodelimplementations"></a>

#### 4.3.5\. Table with _p_-values from comparison of focal measures from model implementations

The [stats_compare_table] function produces publication quality tables of
_p_-values in LaTeX. This function accepts four parameters:

1. `tests` - Type of statistical tests to perform (parametric or
non-parametric).
2. `adjust` - Adjustment to _p_-values for comparison of multiple focal
measures: 'holm', 'hochberg', 'hommel', 'bonferroni', 'BH', 'BY', 'sidak' or
'none'.
3. `pthresh` - Minimum value of _p_-values before truncation (e.g., if this
value is set to 0.001 and a certain _p_-value is less than that, the table will
display "&lt; 0.001".
4. `tformat` - Specifies if outputs appear in the header (0) or in the first
column (1).
5. `varargin` - Variable number of cell arrays containing the following two
items defining a comparison: 
   * Item 1 can take one of three formats: a) zero, 0, which is an indication 
     not to print any type of comparison name; b) a string describing the 
     comparison name; or, c) a cell array of two strings, the first describing a 
     comparison group name, and the second describing a comparison name.
   * Item 2, a cell array of statistical summaries (given by the 
     [stats_gather] function) of the implementations 
     to be compared.

The following command uses data from a [previous example](#comparefocalmeasuresofmultiplemodelimplementations)
and outputs a table of _p_-values returned by the non-parametric, multi-sample
Kruskal-Wallis test for individual focal measures:

```matlab
s800v2 = {sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2};
stats_compare_table('np', 'none', 0.001, 0, {0, s800v2})
```

![compare_ex05](https://cloud.githubusercontent.com/assets/3018963/11904709/e54bee80-a5b9-11e5-9c18-feab61382675.png)

As we are only performing one comparison (for model size 800, parameter set 2),
the third argument is set to 0. For multiple comparisons, it is preferable to
set this parameter to 1, as it puts comparisons along columns and outputs along
rows. The first item in the final argument is set to 0, such that the comparison
name is not printed (which makes sense when the table only contains a single
comparison).

<a name="multiplecomparisonsandcomparisonnames"></a>

#### 4.3.6\. Multiple comparisons and comparison names

In Table 1 of reference [\[4\]][ref4], three comparisons, I, II, and III, are
performed. The comparison name can be specified in item 1 of the variable
argument cell arrays, as shown in the following code:

```matlab
% Specify output names
outputs = {'$P^s$', '$P^w$', '$P^c$', '$\overline{E}^s$', '$\overline{E}^w$', '$\overline{C}$'};

% Determine focal measures
snl400v1 = stats_gather('NL', [datafolder3 '/nl_ok'], 'stats400v1*.txt', outputs, 1000);
sjexok400v1 = stats_gather('JEXOK', [datafolder3 '/j_ex_ok'], 'stats400v1*.txt', outputs, 1000);
sjexns400v1 = stats_gather('JEXNS', [datafolder3 '/j_ex_noshuff'], 'stats400v1*.txt', outputs, 1000);
sjexdiff400v1 = stats_gather('JEXDIFF', [datafolder3 '/j_ex_diff'], 'stats400v1*.txt', outputs, 1000);

% Comparisons to perform, specify name in item 1
cmp1 = {'I', {snl400v1, sjexok400v1}};
cmp2 = {'II', {snl400v1, sjexns400v1 }};
cmp3 = {'III', {snl400v1, sjexdiff400v1}};

% Output comparison table
stats_compare_table({'p', 'np', 'p', 'np', 'p', 'p'}, 'none', 0.000001, 0, cmp1, cmp2, cmp3)
```

![compare_ex06](https://cloud.githubusercontent.com/assets/3018963/11904749/39f23ba6-a5ba-11e5-9f10-d1d42fbd39f8.png)

Here we specify comparison names, I, II, and II, which will be printed in the
table. Note that each comparison tests two model implementations. As such the 
resulting _p_-values come from two-sample tests, i.e., from the parametric 
_t_-test and from the non-parametric Mann-Whitney test.

<a name="comparisongroups"></a>

#### 4.3.7\. Comparison groups

In Table 8 of reference [\[3\]][ref3], ten comparisons are performed. Each
comparison is associated with a model size and parameter set, and tests for
differences between six model implementations. Comparisons are divided in two
groups, according to the parameter set used. This is accomplished by passing a
cell array of two strings (comparison group and comparison name) to the first
item of each comparison. The following code outputs this table:

```matlab
% Specify output names
outputs = {'$P_i^s$', '$P_i^w$', '$P_i^c$', '$\overline{E}^s_i$', '$\overline{E}^w_i$', '$\overline{C}_i$'};

% Determine focal measures for NetLogo replications
snl100v1 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats100v1*.txt', outputs, 1000);
snl200v1 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats200v1*.txt', outputs, 1000);
snl400v1 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats400v1*.txt', outputs, 1000);
snl800v1 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats800v1*.txt', outputs, 1000);
snl1600v1 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats1600v1*.txt', outputs, 1000);
snl100v2 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats100v2*.txt', outputs, 2000);
snl200v2 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats200v2*.txt', outputs, 2000);
snl400v2 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats400v2*.txt', outputs, 2000);
snl800v2 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats800v2*.txt', outputs, 2000);
snl1600v2 = stats_gather('NL', [datafolder2 '/simout/NL'], 'stats1600v2*.txt', outputs, 2000);

% Determine focal measures for Java ST replications
sjst100v1 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats100v1*.txt', outputs, 1000);
sjst200v1 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats200v1*.txt', outputs, 1000);
sjst400v1 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats400v1*.txt', outputs, 1000);
sjst800v1 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats800v1*.txt', outputs, 1000);
sjst1600v1 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats1600v1*.txt', outputs, 1000);
sjst100v2 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats100v2*.txt', outputs, 2000);
sjst200v2 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats200v2*.txt', outputs, 2000);
sjst400v2 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats400v2*.txt', outputs, 2000);
sjst800v2 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats800v2*.txt', outputs, 2000);
sjst1600v2 = stats_gather('ST', [datafolder2 '/simout/ST'], 'stats1600v2*.txt', outputs, 2000);

% Determine focal measures for Java EQ replications, 12 threads
sjeq100v1 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats100v1pEQt12r*.txt', outputs, 1000);
sjeq200v1 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats200v1pEQt12r*.txt', outputs, 1000);
sjeq400v1 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats400v1pEQt12r*.txt', outputs, 1000);
sjeq800v1 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats800v1pEQt12r*.txt', outputs, 1000);
sjeq1600v1 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats1600v1pEQt12r*.txt', outputs, 1000);
sjeq100v2 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats100v2pEQt12r*.txt', outputs, 2000);
sjeq200v2 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats200v2pEQt12r*.txt', outputs, 2000);
sjeq400v2 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats400v2pEQt12r*.txt', outputs, 2000);
sjeq800v2 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats800v2pEQt12r*.txt', outputs, 2000);
sjeq1600v2 = stats_gather('EQ', [datafolder2 '/simout/EQ'], 'stats1600v2pEQt12r*.txt', outputs, 2000);

% Determine focal measures for Java EX replications, 12 threads
sjex100v1 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats100v1pEXt12r*.txt', outputs, 1000);
sjex200v1 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats200v1pEXt12r*.txt', outputs, 1000);
sjex400v1 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats400v1pEXt12r*.txt', outputs, 1000);
sjex800v1 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats800v1pEXt12r*.txt', outputs, 1000);
sjex1600v1 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats1600v1pEXt12r*.txt', outputs, 1000);
sjex100v2 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats100v2pEXt12r*.txt', outputs, 2000);
sjex200v2 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats200v2pEXt12r*.txt', outputs, 2000);
sjex400v2 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats400v2pEXt12r*.txt', outputs, 2000);
sjex800v2 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats800v2pEXt12r*.txt', outputs, 2000);
sjex1600v2 = stats_gather('EX', [datafolder2 '/simout/EX'], 'stats1600v2pEXt12r*.txt', outputs, 2000);

% Determine focal measures for Java ER replications, 12 threads
sjer100v1 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats100v1pERt12r*.txt', outputs, 1000);
sjer200v1 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats200v1pERt12r*.txt', outputs, 1000);
sjer400v1 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats400v1pERt12r*.txt', outputs, 1000);
sjer800v1 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats800v1pERt12r*.txt', outputs, 1000);
sjer1600v1 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats1600v1pERt12r*.txt', outputs, 1000);
sjer100v2 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats100v2pERt12r*.txt', outputs, 2000);
sjer200v2 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats200v2pERt12r*.txt', outputs, 2000);
sjer400v2 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats400v2pERt12r*.txt', outputs, 2000);
sjer800v2 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats800v2pERt12r*.txt', outputs, 2000);
sjer1600v2 = stats_gather('ER', [datafolder2 '/simout/ER'], 'stats1600v2pERt12r*.txt', outputs, 2000);

% Determine focal measures for Java OD replications, 12 threads, b = 500
sjod100v1 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats100v1pODb500t12r*.txt', outputs, 1000);
sjod200v1 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats200v1pODb500t12r*.txt', outputs, 1000);
sjod400v1 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats400v1pODb500t12r*.txt', outputs, 1000);
sjod800v1 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats800v1pODb500t12r*.txt', outputs, 1000);
sjod1600v1 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats1600v1pODb500t12r*.txt', outputs, 1000);
sjod100v2 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats100v2pODb500t12r*.txt', outputs, 2000);
sjod200v2 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats200v2pODb500t12r*.txt', outputs, 2000);
sjod400v2 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats400v2pODb500t12r*.txt', outputs, 2000);
sjod800v2 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats800v2pODb500t12r*.txt', outputs, 2000);
sjod1600v2 = stats_gather('OD', [datafolder2 '/simout/OD'], 'stats1600v2pODb500t12r*.txt', outputs, 2000);

% Group same size/param.set focal measures into comparisons to be performed
s100v1 = {snl100v1, sjst100v1, sjeq100v1, sjex100v1, sjer100v1, sjod100v1};
s200v1 = {snl200v1, sjst200v1, sjeq200v1, sjex200v1, sjer200v1, sjod200v1};
s400v1 = {snl400v1, sjst400v1, sjeq400v1, sjex400v1, sjer400v1, sjod400v1};
s800v1 = {snl800v1, sjst800v1, sjeq800v1, sjex800v1, sjer800v1, sjod800v1};
s1600v1 = {snl1600v1, sjst1600v1, sjeq1600v1, sjex1600v1, sjer1600v1, sjod1600v1};
s100v2 = {snl100v2, sjst100v2, sjeq100v2, sjex100v2, sjer100v2, sjod100v2};
s200v2 = {snl200v2, sjst200v2, sjeq200v2, sjex200v2, sjer200v2, sjod200v2};
s400v2 = {snl400v2, sjst400v2, sjeq400v2, sjex400v2, sjer400v2, sjod400v2};
s800v2 = {snl800v2, sjst800v2, sjeq800v2, sjex800v2, sjer800v2, sjod800v2};
s1600v2 = {snl1600v2, sjst1600v2, sjeq1600v2, sjex1600v2, sjer1600v2, sjod1600v2};

% Comparisons to perform
cmp1 = {{'Param. set 1', '100'}, s100v1};
cmp2 = {{'Param. set 1', '200'}, s200v1};
cmp3 = {{'Param. set 1', '400'}, s400v1};
cmp4 = {{'Param. set 1', '800'}, s800v1};
cmp5 = {{'Param. set 1', '1600'}, s1600v1};
cmp6 = {{'Param. set 2', '100'}, s100v2};
cmp7 = {{'Param. set 2', '200'}, s200v2};
cmp8 = {{'Param. set 2', '400'}, s400v2};
cmp9 = {{'Param. set 2', '800'}, s800v2};
cmp10 = {{'Param. set 2', '1600'}, s1600v2};

% Output comparison table
stats_compare_table('np', 'none', 1e-6, 1, cmp1, cmp2, cmp3, cmp4, cmp5, cmp6, cmp7, cmp8, cmp9, cmp10)
```

![compare_ex07](https://cloud.githubusercontent.com/assets/3018963/11904817/a80b1860-a5ba-11e5-9bb0-38a9ce329b85.png)

We set the `tformat` parameter to 1, as this is more appropriate when many
comparisons are performed.

<a name="unittests"></a>

## 5\. Unit tests

The _SimOutUtils_ unit tests require the [MOxUnit] framework. Set the
appropriate path to this framework as specified in the respective instructions,
`cd` into the [tests] folder and execute the following instruction:

```
moxunit_runtests
```

The tests can take a few minutes to run.

<a name="license"></a>

## 6\. License

[MIT License](LICENSE)

<a name="references"></a>

## 7\. References

<a name="ref1"></a>

[\[1\]][ref1] Fachada N, Lopes VV, Martins RC, Rosa AC. (2016) SimOutUtils -
 Utilities for analyzing simulation output. *Journal of Open Research Software*
4(1):e38. http://doi.org/10.5334/jors.110
<a name="ref2"></a>

[\[2\]][ref2] Fachada N, Lopes VV, Martins RC, Rosa AC. (2015) Towards a
standard model for research in agent-based modeling and simulation. *PeerJ
Computer Science* 1:e36. https://doi.org/10.7717/peerj-cs.36

<a name="ref3"></a>

[\[3\]][ref3] Fachada N, Lopes VV, Martins RC, Rosa AC. (2016) Parallelization
Strategies for Spatial Agent-Based Models. *International Journal of Parallel
Programming*. https://doi.org/10.1007/s10766-015-0399-9 (arXiv version available
at http://arxiv.org/abs/1507.04047)

<a name="ref4"></a>

[\[4\]][ref4] Fachada N, Lopes VV, Martins RC, Rosa AC. (2016) Model-independent
comparison of simulation output. *Under peer-review*. (arXiv version available
at http://arxiv.org/abs/1509.09174)

<a name="ref5"></a>

[\[5\]][ref5] Willink R (2005) A Confidence Interval and Test for the Mean of
an Asymmetric Distribution. *Communications in Statistics - Theory and Methods*
34 (4): 753-766. https://doi.org/10.1081%2FSTA-200054419

<a name="ref6"></a>

[\[6\]][ref6] Gibbons JD, Chakraborti S. (2010) *Nonparametric statistical
inference*. Chapman and Hall/CRC

<a name="ref7"></a>

[\[7\]][ref7] Montgomery DC, Runger GC. (2014) *Applied statistics and
probability for engineers*. John Wiley \& Sons

<a name="ref8"></a>

[\[8\]][ref8] Kruskal WH, Wallis WA. (1952) Use of Ranks in One-Criterion
Variance Analysis. *Journal of the American Statistical Association* 47 (260): 
583–621

[ref1]: #ref1
[ref2]: #ref2
[ref3]: #ref3
[ref4]: #ref4
[ref5]: #ref5
[ref6]: #ref6
[ref7]: #ref7
[ref8]: #ref8
[ref2tables]: https://doi.org/10.7717/peerj-cs.36/supp-2
[Matlab]: http://www.mathworks.com/products/matlab/
[Octave]: https://gnu.org/software/octave/
[NetLogo]: https://ccl.northwestern.edu/netlogo/
[dlmread]: http://www.mathworks.com/help/matlab/ref/dlmread.html
[PPHPC]: https://github.com/fakenmc/pphpc
[matlab2tikz]: http://www.mathworks.com/matlabcentral/fileexchange/22022-matlab2tikz-matlab2tikz
[siunitx]: https://www.ctan.org/pkg/siunitx
[ulem]: https://www.ctan.org/pkg/ulem
[multirow]: https://www.ctan.org/pkg/multirow
[booktabs]: https://www.ctan.org/pkg/booktabs
[LineSpec]: http://www.mathworks.com/help/matlab/ref/linespec.html
[PatchSpec]: http://www.mathworks.com/help/matlab/ref/patch-properties.html
[Willink confidence interval]: https://doi.org/10.1081%2FSTA-200054419
[Bonferroni]: https://en.wikipedia.org/wiki/Bonferroni_correction
[startup]: startup.m
[output_plot]: core/output_plot.m
[stats_get]: core/stats_get.m
[stats_gather]: core/stats_gather.m
[stats_get_pphpc]: core/stats_get_pphpc.m
[stats_get_iters]: core/stats_get_iters.m
[stats_analyze]: core/stats_analyze.m
[stats_table_per_setup]: dist/stats_table_per_setup.m
[dist_plot_per_fm]: dist/dist_plot_per_fm.m
[dist_table_per_setup]: dist/dist_table_per_setup.m
[dist_table_per_fm]: dist/dist_table_per_fm.m
[stats_compare]: compare/stats_compare.m
[stats_compare_pw]: compare/stats_compare_pw.m
[stats_compare_plot]: compare/stats_compare_plot.m
[stats_compare_table]: compare/stats_compare_table.m
[tests]: tests
[MOxUnit]: https://github.com/MOxUnit/MOxUnit
