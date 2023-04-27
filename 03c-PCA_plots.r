setwd("#")
# Load packages------
load_pkg <- rlang::quos(tidyverse, data.table, ggplot2, ggpubr, ggrepel, RColorBrewer, gghighlight)

invisible(lapply(lapply(load_pkg, rlang::quo_name),
                 library,
                 character.only = TRUE
))

# Load data------
covars <- fread("#.txt", stringsAsFactors = F)
dos_rs2814778 <- fread("#.txt", stringsAsFactors = F, select = c("genid", "rs2814778_C(/T)"))
covars <- merge(covars, dos_rs2814778, by="genid")
setnames(covars, "rs2814778_C(/T)", "rs2814778_T")

# PCA with regions------
covars <- covars[!covars$cob_un_regions == "",]
#covars_1 <- covars[cob_afr_divisions %in% c("asia", "europe", "north_america", "south_america"),]
#covars_2 <- covars[!cob_afr_divisions %in% c("asia", "europe", "north_america", "south_america"),]
#covars_1 <- covars_1[order(factor(cob_afr_divisions, levels = c("asia", "europe", "north_america", "south_america"))), .SD, cob_afr_divisions]
#covars <- rbind(covars_1, covars_2)
covars <- covars[order(factor(cob_afr_divisions, levels = c("asia", "europe", "north_america", 
                                                            "south_america", "west_africa", 
                                                            "caribbean", "east_africa", 
                                                            "central_africa", "southern_africa", 
                                                            "north_africa"))), .SD, cob_afr_divisions]
afr_scale <- scale_color_manual(
  breaks = c("asia", "europe", "north_america", "south_america", "caribbean", 
             "central_africa", "east_africa", "southern_africa", "north_africa", "west_africa"),
  values = c("#252525", "#525252", "#737373", "#969696", "#377EB8", "#984EA3", "tan", "#E41A1C", "#FF7F00", "#4DAF4A"),
  labels = c("Asia", "Europe", "North America", "South America", "Caribbean", 
             "Central Africa", "East Africa", "Southern Africa", "North Africa", "West Africa")
)
pca_afr_label <- "Nr. in region:\nAsia = 12\nEurope = 1428\nNorth America = 217\nSouth America = 123\nCaribbean = 1558\nCentral Africa = 232\nEast Africa = 530\nSouthern Africa = 31\nNorth Africa = 3\nWest Africa = 2177"

afr_pca <- ggscatter(covars, x = "PC1", y = "PC2", color = "cob_afr_divisions" ) + 
  xlim(-0.0415, 0.0169) + xlab("PC1 (%11.71)") + 
  ylim(-0.0196, 0.041) + ylab("PC2 (%9.22)") + 
  afr_scale + labs(color = "World continents\nwith African UN regions") + 
  annotate("label", x = -0.040, y = 0.037, label = pca_afr_label, size = 2.1)
# Save plot
ggsave("figures/V_pca_afr_div_points.png", afr_pca, device="tiff", width = 210, height = 210, dpi=300, compression = "lzw", units="mm", bg="white")


# PCA with highlighted regions------
pca_highlight_annot <- c("Highlighted: Caribbean\nN = 1558", "Highlighted: Central Africa\nN = 232", 
                         "Highlighted: East Africa\nN = 530", "Highlighted: Southern Africa\nN = 31", 
                         "Highlighted: North Africa\nN = 3", "Highlighted: West Africa\nN = 2177")
pca_highlighted_caribbean <- ggplot(covars, aes(PC1, PC2, fill = cob_afr_divisions)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("caribbean"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + theme(legend.position = "none")  + xlim(-0.0415, 0.0169) + xlab(" ") + 
  ylim(-0.0196, 0.041) + ylab(" ") + 
  annotate("text", x = -0.025, y = 0.040, label = pca_highlight_annot[1], size = 2.0)
pca_highlighted_central <- ggplot(covars, aes(PC1, PC2, fill = cob_afr_divisions)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("central_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + theme(legend.position = "none")  + xlim(-0.0415, 0.0169) + xlab(" ") + 
  ylim(-0.0196, 0.041) + ylab(" ") + 
  annotate("text", x = -0.025, y = 0.040, label = pca_highlight_annot[2], size = 2.0)
pca_highlighted_east <- ggplot(covars, aes(PC1, PC2, fill = cob_afr_divisions)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("east_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + theme(legend.position = "none")  + xlim(-0.0415, 0.0169) + xlab(" ") + 
  ylim(-0.0196, 0.041) + ylab(" ") + 
  annotate("text", x = -0.025, y = 0.040, label = pca_highlight_annot[3], size = 2.0)
pca_highlighted_south <- ggplot(covars, aes(PC1, PC2, fill = cob_afr_divisions)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("southern_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + theme(legend.position = "none")  + xlim(-0.0415, 0.0169) + xlab(" ") + 
  ylim(-0.0196, 0.041) + ylab(" ") + 
  annotate("text", x = -0.025, y = 0.040, label = pca_highlight_annot[4], size = 2.0)
pca_highlighted_north <- ggplot(covars, aes(PC1, PC2, fill = cob_afr_divisions)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("north_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + theme(legend.position = "none") + xlim(-0.0415, 0.0169) + xlab(" ") + 
  ylim(-0.0196, 0.041) + ylab(" ") + 
  annotate("text", x = -0.025, y = 0.040, label = pca_highlight_annot[5], size = 2.0)
pca_highlighted_west <- ggplot(covars, aes(PC1, PC2, fill = cob_afr_divisions)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("west_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + theme(legend.position = "none")  + xlim(-0.0415, 0.0169) + xlab(" ") + 
  ylim(-0.0196, 0.041) + ylab(" ") + 
  annotate("text", x = -0.025, y = 0.040, label = pca_highlight_annot[6], size = 2.0)

pca_highlighted_all <- ggarrange(pca_highlighted_caribbean, pca_highlighted_central, 
                                 pca_highlighted_east, pca_highlighted_south,
          pca_highlighted_north, pca_highlighted_west, ncol = 3, nrow = 2, labels = c("AUTO"), 
          legend = "none", common.legend = TRUE)
pca_highlighted_all <- annotate_figure(pca_highlighted_all,
                bottom = text_grob("PC1 (%11.71)", color = "black", rot = 0),
                left = text_grob("PC2 (%9.22)", color = "black", rot = 90))
# Save plot
ggsave("figures/pca_afr_div_only_gray.png", pca_highlighted_all, device = "png", units = "mm", 
       dpi = 300, width = 210, height = 210)

# PCA with highlighted regions with countries------
afr_scale <- scale_color_manual(
  breaks = c("antigua_and_barbuda", "barbados", "caribbean", "suriname", "the_guianas"),
  values = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00"),
  labels = c("Antigua and\nBarbuda", "Barbados", "Caribbean\n(non-specific)", "Suriname", "The Guianas")
)
pca_countries_caribbean <- ggplot(covars, aes(PC1, PC2, color = cob_all_countries)) +
  geom_point() +
  gghighlight(cob_all_countries %in% c("antigua_and_barbuda", "barbados", "caribbean", "suriname", "the_guianas"), 
              label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.040, y = 0.040, label = pca_highlight_annot[1], size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.title = element_blank(),
        legend.box = "horizontal", 
        legend.key.size = unit(1.00, 'cm')) + guides(colour = guide_legend(override.aes = list(size=4))) + 
  afr_scale

afr_scale <- scale_color_manual(
  breaks = c("angola", "cameroon", "central_african_republic", "congo", "equatorial_guinea", "sao_tome_and_principe"),
  values = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#FFFF33"),
  labels = c("Angola", "Cameroon", "Caribbean", "Central African\nRepublic", 
             "Democratic Republic\nof the Congo", "Sao Tome\nand Principe")
)
pca_countries_central <- ggplot(covars, aes(PC1, PC2, color = cob_all_countries)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("central_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.040, y = 0.040, label = pca_highlight_annot[2], size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.title = element_blank(),
        legend.box = "horizontal", 
        legend.key.size = unit(1.00, 'cm')) + guides(colour = guide_legend(override.aes = list(size=4))) + 
  afr_scale

afr_scale <- scale_color_manual(
  breaks = c("burundi", "comoros", "kenya", "malawi", "mozambique", 
             "rwanda", "somalia", "seychelles", "tanzania", "uganda", "zambia", "zimbabwe"),
  values = c("#E41A1C", "#855071", "#3982AD", "#459D72", "#5A9D5A", "#83688A",
             "#B45B76", "#EC761D", "#FFAD12", "#FFF32E", "#D6B22D", "#A65628"),
  labels = c("Burundi", "Comoros", "Kenya", "Malawi", "Mozambique", "Rwanda", 
             "Somalia", "Seychelles", "Tanzania", "Uganda", "Zambia", "Zimbabwe")
)
pca_countries_east <- ggplot(covars, aes(PC1, PC2, color = cob_all_countries)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("east_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.040, y = 0.040, label = pca_highlight_annot[3], size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.title = element_blank(),
        legend.box = "horizontal", 
        legend.key.size = unit(1.00, 'cm')) + guides(colour = guide_legend(override.aes = list(size=4))) + 
  afr_scale

afr_scale <- scale_color_manual(
  breaks = c("botswana", "namibia", "south_africa"),
  values = c("#E41A1C", "#377EB8", "#4DAF4A"),
  labels = c("Botswana", "Namibia", "South Africa")
)
pca_countries_south <- ggplot(covars, aes(PC1, PC2, color = cob_all_countries)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("southern_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.040, y = 0.040, label = pca_highlight_annot[4], size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.title = element_blank(),
        legend.box = "horizontal", 
        legend.key.size = unit(1.00, 'cm')) + guides(colour = guide_legend(override.aes = list(size=4))) + 
  afr_scale

afr_scale <- scale_color_manual(
  breaks = c("libya", "sudan"),
  values = c("#E41A1C", "#855071"),
  labels = c("Libya", "Sudan")
)
pca_countries_north <- ggplot(covars, aes(PC1, PC2, color = cob_all_countries)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("north_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.040, y = 0.040, label = pca_highlight_annot[5], size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.title = element_blank(),
        legend.box = "horizontal", 
        legend.key.size = unit(1.00, 'cm')) + guides(colour = guide_legend(override.aes = list(size=4))) + 
  afr_scale

afr_scale <- scale_color_manual(
  breaks = c("benin", "burkina", "gambia", "ghana", "guinea", "liberia", 
             "niger", "nigeria", "senegal", "sierra_leone", "togo", "west_africa"),
  values = c("#F781BF", "#855071", "#3982AD", "#459D72", "#5A9D5A", "#83688A",
             "#B45B76", "#EC761D", "#E41A1C", "#FFF32E", "#D6B22D", "#A65628", "#C65618"),
  labels = c("Benin", "Burkina", "Gambia", "Ghana", "Guinea", "Liberia",
             "Niger", "Nigeria", "Senegal", "Sierra Leone", "Togo", "West Africa\n(Region only)")
)
pca_countries_west <- ggplot(covars, aes(PC1, PC2, color = cob_all_countries)) +
  geom_point() +
  gghighlight(cob_afr_divisions %in% c("west_africa"), label_key = cob_afr_divisions, 
              label_params = list(fill = "black"), unhighlighted_params = list(color = "gray70"), 
              use_group_by = FALSE, use_direct_label = FALSE) + 
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.040, y = 0.040, label = pca_highlight_annot[6], size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.title = element_blank(),
        legend.box = "horizontal", 
        legend.key.size = unit(1.00, 'cm')) + guides(colour = guide_legend(override.aes = list(size=4))) + 
  afr_scale

# Use ggarrange to make a 2x3 grid
pca_countries_all <- ggarrange(pca_countries_caribbean, pca_countries_central, pca_countries_east, pca_countries_south, 
          pca_countries_north, pca_countries_west, 
          ncol = 3, nrow = 2, labels = c("AUTO"), widths = c(1, 1, 1), align = "v")

# Annotate x and y axes
pca_countries_all <- annotate_figure(pca_countries_all,
                                       bottom = text_grob("PC1 (%11.71)", color = "black", rot = 0),
                                       left = text_grob("PC2 (%9.22)", color = "black", rot = 90))
# Save plot
ggsave("figures/pca_afr_div_countries.png", pca_countries_all, device = "png", units = "mm", 
       dpi = 300, width = 494, height = 310)

# PCA with admixture------
covars$GBR <- round(100*covars$GBR)
covars$EA <- round(100*covars$EA)
covars$SA <- round(100*covars$SA)
covars$YRI <- round(100*covars$YRI)

afr_scale <- scale_color_gradientn(
  name = "%",
  breaks = c(0, median(covars$GBR), max(covars$GBR)),
  labels = c(0, median(covars$GBR), max(covars$GBR)),
  space = c("Lab"),
  colors = c("#F7FBFF", "#6BAED6", "#4292C6"),
  limits = c(0, max(covars$GBR))
)
pca_admixture_eur <- ggplot(covars, aes(PC1, PC2, color = GBR)) +
  geom_point() +
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.0410, y = 0.040, label = "Population admixture: European", size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.box = "horizontal") + 
  guides(
    color = guide_colourbar(barwidth = 1.25, 
                            barheight = 10,
                            nbin = 10,
                            title = " %",
                            frame.colour = "black",
                            frame.linewidth = 1.5,
                            ticks = TRUE,
                            ticks.colour = "black",
                            ticks.linewidth = 1.5
                            )
    ) + afr_scale

afr_scale <- scale_color_gradientn(
  name = "%",
  breaks = c(0, median(covars$EA), max(covars$EA)),
  labels = c(0, median(covars$EA), max(covars$EA)),
  space = c("Lab"),
  colors = c("#FFF7EC", "#FDBB84", "#EF6548"),
  limits = c(0, max(covars$EA))
)
pca_admixture_ea <- ggplot(covars, aes(PC1, PC2, color = EA)) +
  geom_point() +
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.0410, y = 0.040, label = "Population admixture: East Asian", size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.box = "horizontal") + 
  guides(
    color = guide_colourbar(barwidth = 1.25, 
                            barheight = 10,
                            nbin = 10,
                            title = " %",
                            frame.colour = "black",
                            frame.linewidth = 1.5,
                            ticks = TRUE,
                            ticks.colour = "black",
                            ticks.linewidth = 1.5
    )
  ) + afr_scale

afr_scale <- scale_color_gradientn(
  name = "%",
  breaks = c(0, median(covars$SA), max(covars$SA)),
  labels = c(0, median(covars$SA), max(covars$SA)),
  space = c("Lab"),
  colors = c("#FCFBFD", "#BCBDDC", "#807DBA"),
  limits = c(0, max(covars$SA))
)
pca_admixture_sa <- ggplot(covars, aes(PC1, PC2, color = SA)) +
  geom_point() +
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.0410, y = 0.040, label = "Population admixture: South Asian", size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.box = "horizontal") + 
  guides(
    color = guide_colourbar(barwidth = 1.25, 
                            barheight = 10,
                            nbin = 10,
                            title = " %",
                            frame.colour = "black",
                            frame.linewidth = 1.5,
                            ticks = TRUE,
                            ticks.colour = "black",
                            ticks.linewidth = 1.5
    )
  ) + afr_scale

afr_scale <- scale_color_gradientn(
  name = "%",
  breaks = c(80, median(covars$YRI), max(covars$YRI)),
  labels = c(80, median(covars$YRI), max(covars$YRI)),
  space = c("Lab"),
  colors = c("#E5F5E0", "#74C476", "#00441B"),
  limits = c(80, max(covars$YRI))
)
pca_admixture_afr <- ggplot(covars, aes(PC1, PC2, color = YRI)) +
  geom_point() +
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("text", x = -0.0410, y = 0.040, label = "Population admixture: African", size = 3.0, hjust = 0) +
  theme(legend.position = "right",
        legend.box = "horizontal") + 
  guides(
    color = guide_colourbar(barwidth = 1.25, 
                            barheight = 10,
                            nbin = 10,
                            title = " %",
                            frame.colour = "black",
                            frame.linewidth = 1.5,
                            ticks = TRUE,
                            ticks.colour = "black",
                            ticks.linewidth = 1.5
    )
  ) + afr_scale

# ggarrange
pca_admixture_all <- ggarrange(pca_admixture_eur, pca_admixture_ea, pca_admixture_sa, pca_admixture_afr,
                               labels = "AUTO", nrow = 2, ncol = 2)
# Annotate x and y axes
pca_admixture_all <- annotate_figure(pca_admixture_all,
                                     bottom = text_grob("PC1 (%11.71)", color = "black", rot = 0),
                                     left = text_grob("PC2 (%9.22)", color = "black", rot = 90))

# Save plot
ggsave("figures/pca_afr_admixture.png", pca_admixture_all, device = "png", units = "mm", 
       dpi = 300, width = 297, height = 297)


# PCA with duffy allele dosage------
covars <- covars[order(-rs2814778_T)]
covars$rs2814778_T <- as.character(covars$rs2814778_T)
covars <- covars[!is.na(nc_log)]
table(covars[!is.na(nc_log),rs2814778_T])
afr_scale <- scale_color_manual(
  breaks = c("0", "1", "2"),
  values = c("red", "blue", "gray70"),
  labels = c("TT", "TC", "CC")
)
pca_dosage <- ggplot(covars, aes(PC1, PC2, color = rs2814778_T)) +
  geom_point() +
  theme_pubr() + xlim(-0.0415, 0.0169) + xlab(" ") + ylim(-0.0196, 0.041) + ylab(" ") +
  annotate("label", x = -0.040, y = 0.040, label = "Sample-size:\nTT = 14\nTC = 399\nCC = 5566", size = 3.0, hjust = 0) +
  theme(legend.position = "top",
        legend.title = element_blank(),
        legend.box = "vertical", 
        legend.key.size = unit(1.00, 'cm')) + guides(colour = guide_legend(override.aes = list(size=4))) + 
  afr_scale

# Save plot
ggsave("#.tiff", pca_dosage, 
  device="tiff", width = 210, height = 210, dpi=300, compression = "lzw", units="mm", bg="white")

