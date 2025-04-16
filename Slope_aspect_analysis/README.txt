# UAV-Based Slope and Aspect Analysis in Larsemann Hills, East Antarctica

This repository contains MATLAB code for analyzing slope and aspect characteristics of the **Larsemann Hills**, East Antarctica. The code is part of the data analysis workflow for the research article:

**"Mapping the Paleo Ice-Flow in Larsemann Hills, East Antarctica by UAV Remote Sensing and Terrain Analysis"**

---

## 📌 Description

The script included here generates **pie charts of slope aspect distributions** for six defined sub-regions within the Larsemann Hills. It forms a key part of the terrain analysis used to infer past glacial movement patterns based on high-resolution UAV-derived DEMs.

- **Visualization**: Aspect distributions are presented using color-customized pie charts.
- **Customization**: The script applies semi-transparent color schemes and adjusts label positions for publication-quality figures.
- **Segmentation**: The region is divided into **6 subzones**, and statistics are computed separately for each.

---

## 📁 Files

- `aspect_pie_plot.m`: The main script for generating the slope aspect pie charts.
- `colorExchange.m`: A helper function to convert RGB values to MATLAB color format.
- `Fig_output/`: Folder for storing output images (`.png`, transparent background, high resolution).

> ⚠️ **Note:** Due to the large size of the original UAV dataset and derived slope/aspect rasters, we have not uploaded the source data. If you require access for academic purposes, feel free to contact me.

---

## 📬 Contact

For data access or questions related to the code or publication, please contact:

**Li Yibo**  
Email: [liyb76@mail2.sysu.edu.cn](mailto:liyb76@mail2.sysu.edu.cn)  
Affiliation: Sun Yat-sen University

---

## 📄 Citation

If you find this code useful in your research, please cite the original paper (coming soon). Preprint and publication links will be added once available.

---

## 🔧 Requirements

- MATLAB R2018b or later (for full compatibility with export settings)
- [export_fig toolbox](https://github.com/altmany/export_fig) (for high-resolution figure output)

---

Thanks for your interest!
