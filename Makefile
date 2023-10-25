.PHONY: clean

clean:
	rm -f generate/*
	
generate/cleaned.csv: project/source_data/updated/job_postings.csv\
 project/code/prepare.r
	Rscript project/code/prepare.r

generate/plot1.png generate/plot2.png generate/plot3.png generate/plot4.png:\
 generate/cleaned.csv project/code/insight_plot.r
	Rscript project/code/insight_plot.r