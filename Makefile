.PHONY: clean

clean:
	rm -f output/*
	
output/cleaned.csv: project/source_data/updated/job_postings.csv\
 project/code/prepare.r
	Rscript project/code/prepare.r

output/plot1.png output/plot2.png output/plot3.png output/plot4.png output/plot5.png:\
 output/cleaned.csv project/code/insight_plot.r
	Rscript project/code/insight_plot.r
	
project/code/writeup_report.html: project/code/writeup_report.Rmd output/plot1.png\
 output/plot2.png output/plot3.png output/plot4.png output/plot5.png
	R -e "rmarkdown::render(\"project/code/writeup_report.Rmd\", output_format=\"html_document\")"