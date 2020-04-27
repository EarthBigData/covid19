object = ebd_covid19.ipynb
all:
	cd /s/notebooks/covid19
	# ./Build_US_TimeSeries.py
	# wget -O /s/data/covid19/time_series_19-covid-Confirmed.csv https://www.soothsawyer.com/wp-content/uploads/2020/03/time_series_19-covid-Confirmed.csv
	# wget -O /s/data/covid19/time_series_19-covid-Deaths.csv https://www.soothsawyer.com/wp-content/uploads/2020/03/time_series_19-covid-Deaths.csv
	jupyter nbconvert --execute $(object) --to html --no-input --output-dir /s/notebooks/covid19/html
	git pull
	git add .
	git commit -m "Automatic update"
	git push
	aws s3 cp /s/notebooks/covid19/html/ebd_covid19.html s3://ebd-covid19/index.html

master2html:
	cd /s/notebooks/covid19
	/s/anaconda/envs/seppo/bin/jupyter nbconvert  --ExecutePreprocessor.timeout=-1 --execute $(object) --to html --no-input --output-dir /s/notebooks/covid19/html
	aws s3 cp /s/notebooks/covid19/html/ebd_covid19.html s3://ebd-covid19/index.html

dev2html:
	cd /s/notebooks/covid19
	/s/anaconda/envs/seppo/bin/jupyter nbconvert --execute dev_$(object) --to html --no-input --output-dir /s/notebooks/covid19/dev_html
	aws s3 cp /s/notebooks/covid19/dev_html/dev_ebd_covid19.html s3://ebd-covid19/index2.html

master2dev:
	cp $(object) dev_$(object) 

dev2master:
	cp dev_$(object) $(object)

upload:
	aws s3 cp /s/notebooks/covid19/html/ebd_covid19.html s3://ebd-covid19/index.html

clear:
	jupyter nbconvert --clear-output $(object)


