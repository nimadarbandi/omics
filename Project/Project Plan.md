My project will be based on a paper with a topic

Knock-out of CD73 delays the onset of HR-negative breast cancer by reprogramming lipid metabolism and is associated with increased tumor mutational burden

CD73 reprograms lipid metabolism through a regulatory loop with PR and PPARγ.
Its disruption through low CD73 expression/CD73 KO enhances tumor mutational burden.
CD73 KO delays the onset of HR-negative tumors in the breast cancer model.
Paper link:
https://www.sciencedirect.com/science/article/pii/S2212877824001662
Link to data:
https://www.ncbi.nlm.nih.gov/sra/?term=PRJNA933922
https://www.ncbi.nlm.nih.gov/sra/SRX27730892[accn]

Project Phases
Data Acquisition
• The sequencing data from the SRA using the accession number PRJNA933922 (e.g., using the SRA Toolkit).
https://www.ncbi.nlm.nih.gov/sra/?term=PRJNA933922
Data Pre-processing
• assess the quality of raw sequencing reads.
• trim low-quality bases and remove adapters, ensuring high-quality data for downstream analysis.
Alignment and Mapping
• Mapping the trimmed reads to the Mus musculus reference genome (GRCm39)
https://www.ncbi.nlm.nih.gov/sra/SRX27730892[accn]
Differential Gene Expression Analysis
• Perform differential expression analysis using DESeq2
• Comparing wild-type versus CD73 KO samples and identifying differentially expressed genes (DEGs).
Functional Enrichment and Pathway Analysis
• Pathway analysis on the DEGs to explore lipid metabolism and related pathways.
Visualization and Interpretation
• Compare findings with the results reported in the paper, focusing on the regulatory loop involving CD73, PR, and PPARγ.
Documentation and Reporting