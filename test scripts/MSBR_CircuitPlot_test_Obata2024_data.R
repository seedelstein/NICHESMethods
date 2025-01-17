# Test work with Sophie's data

# Dependencies
require(ggplot2)
require(Seurat)
library(devtools)

# Step 1: Pull most recent NICHESMethods branch from cloud with GitHub desktop

# Step 2: Set WD to GitHub/NICHESMethods
setwd("/Users/msbr/GitHub/NICHESMethods")

# Step 3: Load the package from local copy
getwd() # confirm that in the right place
load_all() # load local package
check() # check that it works

# sophie's data
load("/Volumes/RaredonLab-CC1126-MEDANE/Raredon_Lab_Personal_Folders/Sophie/Single Cell/Single Cell Samples - Nuoya Collaboration/BAMC/BAMC.CTC.integrated.Robj")
load("/Volumes/RaredonLab-CC1126-MEDANE/Raredon_Lab_Personal_Folders/Sophie/Single Cell/Single Cell Samples - Nuoya Collaboration/BAMC/BAMC.integrated_NAs.Robj")



# inspect
color_pal <- c('#A40606','#9CFFFA','#B0DB43','#9C528B','#2F6690',
               '#946846','#F1C40F','green','#0F0326','#E65F5C','#14591D','#726DA8',
               'yellow','purple','blue','red','orange','darkgrey','magenta')
color_pal <- color_pal[1:length(unique(node.object$New_Annotations))]
names(color_pal) <- unique(node.object$New_Annotations)


Seurat::DimPlot(BAMC.CTC.integrated,label = T, reduction = "umap.rpca")
Seurat::DimPlot(BAMC.CTC.integrated,group.by = 'SendingType',cols = New_Annotations.Sending, reduction = "umap.rpca")
Seurat::DimPlot(BAMC.CTC.integrated,group.by = 'ReceivingType',cols = New_Annotations.Receiving,reduction = "umap.rpca")
FeaturePlot(BAMC.CTC.integrated,'Igf1—Igf1r', reduction = "umap.rpca")
FeaturePlot(BAMC.CTC.integrated,'Areg—Egfr', reduction = "umap.rpca")

mark <- FindAllMarkers(BAMC.CTC.integrated,min.pct = 0.5)
mark$ratio <- mark$pct.1/mark$pct.2

# test
node.object <- DefineNodeObject(transcr.obj = BAMC.integrated,
                                feature = 'Il24')

edge.object <- DefineEdgeObject(connect.obj = BAMC.CTC.integrated,
                                feature = 'Il24—Il22ra1',
                                assay = 'CellToCell')

node.aggregate <- AggregateNodeData(node.object = node.object,
                                    group.by = 'New_Annotations',
                                    global.node.list = unique(node.object$New_Annotations))

edge.aggregate <- AggregateEdgeData(edge.object = edge.object,
                                    group.by = 'New_Annotations.Joint')
# test ggCircuit

global.node.list = unique(node.object$New_Annotations)
ggCircuit(node.aggregate = node.aggregate,
          edge.aggregate = edge.aggregate,
          offset = 0.05, # distance between the opposing arrows
          edge.fixed.size = T, # true means edge.scale.factor does nothing
          edge.scale.factor = 1, # bigger means thinner arrows
          graph.angle = 25, # this should be a function of number of nodes
          h = 0.05, # hypotenuse length for trig that spaces the arrows from the circles
          autocrine.offset = 0.01, # size of autocrine cricle diameter
          arrow.head.angle = 10, # fatness of arrows
          arrow.head.length = 0.02, # obvious, size of arrow tip threads
          autocrine.arrow.curvature = 20,# size of autocrine cricle diameter ???
          cols.use = color_pal)

# Final step: test CircuitPlot function - for sophie to complete
# 1. see if you can get CircuitPlot working, kind of like this (you will need to change some parameters)
CircuitPlot(transcr.obj = lung.combined,
            connect.obj = cell.to.cell,
            feature = 'Vegfa—Kdr',
            group.by = 'CellClass',
            graph.angle = 45,
            h = 0.2,
            offset = 0.05,
            autocrine.offset = 0.02,
            edge.scale.factor = 20,
            arrow.head.angle = 15,
            arrow.head.length = 0.03,
            autocrine.arrow.curvature = 10,
            cols.use = ,
            edge.fixed = T)

## Network Plot

NetworkPlot(transcriptome.object = BAMC.integrated,
            connectome.object = BAMC.CTC.integrated,
            mechanism.of.interest = 'Il24—Il22ra1',
            reduction = 'umap.rpca',
            legends.to.plot = NULL)

NetworkPlot(transcriptome.object = BAMC.integrated,
            connectome.object = BAMC.CTC.integrated,
            mechanism.of.interest = 'Gpha2—Tshr',
            reduction = 'umap.rpca',
            legends.to.plot = NULL)

NetworkPlot(transcriptome.object = BAMC.integrated,
            connectome.object = BAMC.CTC.integrated,
            mechanism.of.interest = 'Fgf9—Fgfr3',
            reduction = 'umap.rpca',
            legends.to.plot = NULL)

NetworkPlot(transcriptome.object = BAMC.integrated,
            connectome.object = BAMC.CTC.integrated,
            mechanism.of.interest = 'Vegfa—Kdr',
            reduction = 'umap.rpca',
            legends.to.plot = NULL)

NetworkPlot(transcriptome.object = BAMC.integrated,
            connectome.object = BAMC.CTC.integrated,
            mechanism.of.interest = 'Tgfb1—Tgfbr1',
            reduction = 'umap.rpca',
            legends.to.plot = NULL)
require(Seurat)

split.tra <- SplitObject(BAMC.integrated,split.by = 'orig.ident')
split.ctc <- SplitObject(BAMC.CTC.integrated,split.by = 'orig.ident.Joint')

load_all()
FOI <- 'Tgfb1—Tgfbr1'
p1 <- NetworkPlot(transcriptome.object = split.tra[[1]],
            connectome.object = split.ctc[[1]],
            mechanism.of.interest = FOI,
            reduction = 'umap.rpca',
            legends.to.plot = NULL)+xlim(-10,15)+ylim(-15,12)
p2 <- NetworkPlot(transcriptome.object = split.tra[[2]],
                  connectome.object = split.ctc[[2]],
                  mechanism.of.interest = FOI,
                  reduction = 'umap.rpca',
                  legends.to.plot = NULL)+xlim(-10,15)+ylim(-15,12)
p3 <- NetworkPlot(transcriptome.object = split.tra[[3]],
                  connectome.object = split.ctc[[3]],
                  mechanism.of.interest = FOI,
                  reduction = 'umap.rpca',
                  legends.to.plot = NULL)+xlim(-10,15)+ylim(-15,12)
cowplot::plot_grid(p1,p2,p3)

