import pandas as pd
import matplotlib.pyplot as plt
import iris

def buildGraph(filename,xSeriesName,ySeriesName):
    rs=iris.sql.exec("select Year,Beer,LowMaltBeer from Sample.Alcohol")
    df=rs.dataframe()
    df[[xSeriesName,ySeriesName]].plot(title="Tokyo")
    plt.savefig(filename)