<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.wolterskluwer.gpd.monitor.pack.atlas.*"%>
<%@ page import="com.wolterskluwer.gpd.service.*"%>
<%@ page import="com.wolterskluwer.gpd.common.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GPD</title>

<script src="media/js/jquery-1.6.2.js"></script>
<script src="media/js/jquery.cookie.js"></script>
<script src="media/js/jquery-ui.min.js"></script>
<script type="text/javascript" language="javascript"
	src="media/js/jquery.dataTables.js"></script>
<script type="text/javascript" language="javascript"
	src="media/js/jqueryui.datatables.js"></script>
<script>
		var ajaxFn = null;	
			/* $(function() {
				$("#tabs").tabs({ cookie: { expires: 30 } });
			  }); */
			  
			  $(document).ready(function(){
				  
				  function ajax_Function(calledFor){
						$.ajax({
				                type:"GET",
				                url: "admin",
  								data: {"calledFor":calledFor},
  								success:  function( responseText ) {
				                 $('#pollResponseDiv').html(responseText);
				                 if (! (responseText.startsWith("<a target") || responseText.startsWith("Sitemaps were not generated"))){
				                	 setTimeout(ajaxFn(calledFor), 5000);
				                 }else{
				                	 hideInProgress();
				                 }
				                }
						});
					}	
				  ajaxFn = ajax_Function;
				  
				  hideInProgress();
				    //initialize tabs plugin with listening on activate event
				    var tabs = $("#tabs").tabs({
				    	activate: function(event, ui){
				            //get the active tab index
				            var active = $("#tabs").tabs("option", "active") + 1;

				            //save it to cookies
				            $.cookie("activeTabIndex", active);
				        }
				    });
				    
				    //read the cookie
				    var activeTabIndex = $.cookie("activeTabIndex");

				    //make active needed tab
				    if(activeTabIndex !== undefined) {
				        /* tabs.tabs("option", "active", activeTabIndex); */
				    	/* $('#tabs ul').tabs('select', activeTabIndex); */
				    	$('#tabs ul a[href=#tabs-' + activeTabIndex +']').trigger('click');
				    }
					
					$("#generateSitemap").click(function() {
					//	alert("CalledFor: generateSitemap");
				        $.get(
				                "admin",{"calledFor":"generateSitemap"},				              
				                function( responseText ) {
				                 showInProgress("generateSitemap");
				                 ajaxFn("generateSitemap");
				                 
				                }
				        );
				    });
				    $("#generateHtmls").click(function() {
				    //	alert("CalledFor: generateHtml");
				        $.get(
				        		"admin",{"calledFor":"generateHtmls"},					              
				                function( responseText ) {
				                 showInProgress("generateHtmls");
				                 ajaxFn("generateHtmls");
				                 
				                }
				        );
				    });				    
				});
		
			  function hideInProgress() {
					document.getElementById('InProgressdiv').style.display = "none";
					document.getElementById('inProgressMsg').style.display = "none";
				}
				function showInProgress(process) {				

					if (process == 'generateHtmls') {
						document.getElementById('InProgressdiv').style.display = "block";
						document.getElementById('inProgressMsg').style.display = "block";
						$('#inProgressMsg').text(
								"HTML Generation is in progress. Please wait.");
					} else if (process == 'generateSitemap') {
						document.getElementById('InProgressdiv').style.display = "block";
						document.getElementById('inProgressMsg').style.display = "block";
						$('#inProgressMsg').text(
								"SiteMap Generation is in progress. Please wait.");
					}
				}

			function submitForm(calledFor){
					  $('#calledFor').val(calledFor);		
					  document.forms["home"].submit();	
					  showInProgress(calledFor);
				}
			
			function canMonitor() {
				var packMonitorRunning = '<%=((Boolean) request.getAttribute("packMonitorRunning"))%>';
				if(packMonitorRunning == 'true'){
					$('.startPack').hide();
					$('.stopPack').show();
					}else
					{
						$('.stopPack').hide();
						$('.startPack').show();
					}
				var htmlMonitorRunning = '<%=((Boolean) request.getAttribute("htmlMonitorRunning"))%>';
		if (htmlMonitorRunning == 'true') {
			$('.startHtml').hide();
			$('.stopHtml').show();
		} else {
			$('.stopHtml').hide();
			$('.startHtml').show();
		}
	}

	function togglePackMonitor() {
		if ($('.stopPack').is(":visible")) {
			$('.stopPack').hide();
			$('.startPack').show();
		} else {
			$('.startPack').hide();
			$('.stopPack').show();
		}
		submitForm('togglePackMonitor');
	}

	function toggleHtmlMonitor() {
		if ($('.stopHtml').is(":visible")) {
			$('.stopHtml').hide();
			$('.startHtml').show();
		} else {
			$('.startHtml').hide();
			$('.stopHtml').show();
		}
		submitForm('toggleHtmlMonitor');
	}

	function viewSiteMapLink() {
		var url = "sitemap/" + $('#productIdForSitemap').val() + "/"
				+ $('#SitemapFileName').val();
		window.open(url);
	}
	
	
	function checkSiteMapLink() {
		var url = "rest/checkDoc/" + $('#productIdToCheck').val() + "/"
				+ $('#docIdToCheck').val();
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("GET", url, true);
		xmlhttp.send();
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == "200") {
				var response = xmlhttp.responseText;
				$(document).ready(function() {
					$('#viewDiv').text(xmlhttp.responseText);
				});
			}
		};

	}

	function viewCustomSiteMapLink() {
		var url = "rest/read/customSitemap/"
				+ $('#productIdForCustomSitemap').val();
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("GET", url, true);
		xmlhttp.send();
		xmlhttp.onreadystatechange = function() {
			if (this.readyState == 4 && this.status == 200) {
				xmlTable(this);
			}
			if (this.readyState == 4 && this.status == 404){		
				document.getElementById("CustomSitemapTable").innerHTML = "<tr><td>Sitemap File cannot be found for::"+$('#productIdForCustomSitemap').val()+"</td></tr>";
				document.getElementById("addSitemap").style.display = "none";
			}
		};
	}
	
	function xmlTable(xml){
		var i;
		var xmlDoc = xml.responseXML;
		var table="<tr><th>Location</th><th>Last Modification</th><th>Change Frequency</th><th>Priority</th><th>Delete</th></tr>";
		var x = xmlDoc.getElementsByTagName("url");
		  for (i = 0; i <x.length; i++) { 
			  var loc=x[i].getElementsByTagName("loc")[0].childNodes[0].nodeValue;
			  var lastmod=x[i].getElementsByTagName("lastmod")[0].childNodes[0].nodeValue;
			  var changefreq=x[i].getElementsByTagName("changefreq")[0].childNodes[0].nodeValue;
			  var priority=x[i].getElementsByTagName("priority")[0].childNodes[0].nodeValue ;
			  
			  
			  table += "<tr><td>" + loc+
			    "</td><td>" + lastmod +
			    "</td><td>"+ changefreq +
			    "</td><td>" + priority +
			    "<td onclick='deleteCustomSiteMapLink(\"" + loc + "\")'> <center><img src='delete.png' height='10' width='10'></center></td></tr>";
			    
		  }
		  document.getElementById("CustomSitemapTable").innerHTML = table;
		  document.getElementById("addSitemap").style.display = "block";
		  
	}
	function editInfo(loc,lastmod,changefreq,priority){
		var doc = document.implementation.createDocument("", "", null);
		var urlsetNode = doc.createElement("urlset");

		var urlNode = doc.createElement("url");
		
		var locNode=doc.createElement("loc");
		locNode.textContent=loc;
	
		var lastmodNode=doc.createElement("lastmod");
		lastmodNode.textContent=lastmod;
		
		var changefreqNode=doc.createElement("changefreq");
		changefreqNode.textContent=changefreq;
		
		var priorityNode=doc.createElement("priority");
		priorityNode.textContent=priority;
		
		urlNode.appendChild(locNode);
		urlNode.appendChild(lastmodNode);
		urlNode.appendChild(changefreqNode);
		urlNode.appendChild(priorityNode);
		
		urlsetNode.appendChild(urlNode);
		
		doc.appendChild(urlsetNode);
		
		addCustomSiteMapLink(doc);
		
	}
	
	function deleteCustomSiteMapLink(loc) {
		var url = "rest/deleteURL/customSitemap/"
			+ $('#productIdForCustomSitemap').val();
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("DELETE", url, true);
		xmlhttp.setRequestHeader("Accept", "text/plain");
		xmlhttp.setRequestHeader("Content-type", "text/plain");
		xmlhttp.send(loc);
		setTimeout(viewCustomSiteMapLink, 100);
	}
	
	function addCustomSiteMapLink(xml) {
		var url = "rest/update/customSitemap/"
				+ $('#productIdForCustomSitemap').val();
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("PUT", url, true);
		xmlhttp.setRequestHeader("Accept", "application/xml");
		xmlhttp.setRequestHeader("Content-type", "application/xml");
		xmlhttp.send(xml);
		document.getElementById("addDiv").style.display = "none";
		setTimeout(viewCustomSiteMapLink, 1000);
	
	}

	function addSitemapFunc() {
		var x = document.getElementById("addDiv");
		if (x.style.display == "none") {
			x.style.display = "block";
		} else {
			x.style.display = "none";
		}
	}

	
	function submitSitemapFunc() {
		var loc = document.getElementById("addLoc").value;
		var lastmod = document.getElementById("addLastMod").value;
		var changefreq = document.getElementById("addCF").value;
		var priority = document.getElementById("addPriority").value;
		if (priority == '' && loc=='' && changefreq=='') {
			alert("All are mandatory fields. Please fill it.");
		} else {
			editInfo(loc, lastmod, changefreq, priority);
		}
	}

	function viewHtmlLink() {
		var url = "document/" + $('#viewProductIdForHtml').val() + "/"
				+ $('#docIdForHtml').val();
		window.open(url);
	}
	function showProduct() {
		var property = document.getElementById("property1");
		var propertyValue = property.options[property.selectedIndex].value;
		if (propertyValue != '') {
			for (i = 0; i < property.options.length; i++) {
				var currentValue = property.options[i].value;
				if (currentValue != '') {
					if (currentValue == propertyValue) {
						document.getElementById('row1_' + currentValue).style.display = 'block';
						document.getElementById('row2_' + currentValue).style.display = 'block';
					} else {
						document.getElementById('row1_' + currentValue).style.display = 'none';
						document.getElementById('row2_' + currentValue).style.display = 'none';
					}
				}
			}
		} else {
			for (i = 0; i < property.options.length; i++) {
				if (property.options[i].value != '') {
					document
							.getElementById('row1_' + property.options[i].value).style.display = 'block';
					document
							.getElementById('row2_' + property.options[i].value).style.display = 'block';
				}
			}
		}

	}
</script>
<style type="text/css">
@import "media/css/style.css";

@import "media/css/jquery.css";

@import "media/css/cupertino/jquery.ui.all.css";

@import "media/css/jquery.dataTables.css";

@import "media/css/jqueryui.datatables.css";
</style>

</head>
<body onload="canMonitor()">
	<form name="home" id="home" method="post">
		<div id="status"></div>
		<input type="hidden" name="calledFor" id="calledFor" value="" />
		<H1>Welcome to Global Product Discoverability (GPD)</H1>
		<div align="right">
			<b>GPD Version: <%=GpdConfig.getString("gpd.version")%></b>
		</div>
		<div id="tabs">
			<ul>
				<li><a href="#tabs-1">Monitor</a></li>
				<li><a href="#tabs-2">View</a></li>
				<li><a href="#tabs-3">Utils</a></li>
				<li><a href="#tabs-4">View Properties</a></li>
				<li><a href="#tabs-5">Custom Sitemap</a></li>

			</ul>
			<div id="InProgressdiv" style="display: block;" align="center"
				border="0">
				<table align="center" width="100%" border="0" cellpadding="3"
					<tr  width="100%"><td align="center" width="40%" ><img src="loading.gif" id="spinnerImg" align="right"  width="20" height="20" border="0"/> 
				</td><td id="inProgressMsg" align="left"  width="60%" ><label id="inProgressMsg" valign="center"> HTML Generation is in progress. Please wait.</label></td>
				</td></tr></table>
			</div>
			<div id="tabs-1">
				<table align="center" width="100%" border="0" cellpadding="2"
					cellspacing="2" class="ui-widget ui-widget-content ui-corner-all">
					<tr>
						<td>Pack Monitoring</td>
						<td>
							<button onclick="togglePackMonitor()" class="stopPack">Stop
								Pack Monitor</button>
							<button onclick="togglePackMonitor()" class="startPack"
								style="display: none;">Start Pack Monitor</button>
						</td>
					</tr>
					<tr>
						<td>Html Monitoring</td>
						<td>
							<button onclick="toggleHtmlMonitor()" class="stopHtml">Stop
								Html Generation</button>
							<button onclick="toggleHtmlMonitor()" class="startHtml"
								style="display: none;">Start Html Generation</button>
						</td>
					</tr>
					<tr>
						<td>View Products</td>
						<td><select id="productIdForHtml" name="productIdForHtml">
								<%
									for (String s : ProductService.getProductIds()) {
								%>
								<option value="<%=s%>"><%=s%></option>
								<%
									}
								%>
						</select></td>
					</tr>
					<tr>
						<td>Poll Products</td>
						<td><input type="button" name="pollJrun" id="pollJrun"
							value="Poll" onclick="submitForm('pollJrun')" /></td>
					</tr>
				</table>
			</div>
			<div id="tabs-2">
				<table align="center" width="100%" border="0" cellpadding="2"
					cellspacing="2" class="ui-widget ui-widget-content ui-corner-all">
					<tr>
						<td>View/Download file for ProductID: <!-- <input type="text"
							id="productIdForHtml" name="productIdForHtml" value="Jaguar-5" /> -->
							<select id="viewProductIdForHtml" name="viewProductIdForHtml">
								<%
									for (String s : ProductService.getProductIds()) {
								%>
								<option value="<%=s%>"><%=s%></option>
								<%
									}
								%>
						</select> Docid(without extension): <input type="text" id="docIdForHtml"
							name="docIdForHtml" value="09013e2c834f58a0" />
						</td>
						<td><input width="100" type="button" name="viewHtml"
							id="viewHtml" value="View Html" onclick="viewHtmlLink()" /></td>
					</tr>
					<tr>
						<!-- <td><input width="100" type="button" name="viewSitemap" id="viewSitemap" value="View Sitemap" onclick="submitForm('viewSitemap')"/></td> -->
						<td>View Sitemap file for ProductID: <!-- <input type="text"
							id="productIdForSitemap" name="productIdForSitemap"
							value="GPD-Test" />  --> <select id="productIdForSitemap"
							name="productIdForSitemap">
								<%
									for (String s : ProductService.getProductIds()) {
								%>
								<option value="<%=s%>"><%=s%></option>
								<%
									}
								%>
						</select> Sitemap File Name (with extension): <input type="text"
							id="SitemapFileName" name="SitemapFileName"
							value="SiteMap_WKUS_TAL_15482_0.xml" />
						</td>
						<td><input width="100" type="button" name="viewSitemap"
							id="viewSitemap" value="View Sitemap" onclick="viewSiteMapLink()" /></td>
					</tr>
					<tr>
						<td>ProductID: <select id="productIdToCheck"
							name="productIdToCheck">
								<%
									for (String s : ProductService.getProductIds()) {
								%>
								<option value="<%=s%>"><%=s%></option>
								<%
									}
								%>
						</select> Document Id <input type="text"
							id="docIdToCheck" name="docIdToCheck"/>
						</td>
						<td><input width="100" type="button" name="checkSitemap"
							id="checkSitemap" value="Check" onclick="checkSiteMapLink()" /></td>
					</tr>
					<tr>
						<td>Get MD5 Checksum: <input type="text" id="getPathForDocId"
							name="getPathForDocId" value="20140312T1342305750500d3e1885" />
						</td>
						<td><input width="100" type="button" name="getPath"
							id="getPath" value="Get Path" onclick="submitForm('getPath')" /></td>
					</tr>
				</table>
				<div
					id="viewDiv" style="margin: 2px; height: 150px; border: 1px solid black; overflow: scroll;">
					<%=request.getAttribute("pollResponse")%>
				</div>
			</div>
			<div id="tabs-3">
				<table align="center" width="100%" border="0" cellpadding="2"
					cellspacing="2" class="ui-widget ui-widget-content ui-corner-all">
					<!-- <tr>
						<td>Get Document XML for docid:<input type="text" id="docid"
							name="docid" value="09013e2c88075744" /></td>
						<td><input width="100" type="button" name="getDocument"
							id="getDocument" value="Get Document"
							onclick="submitForm('getDocument')" /></td>
					</tr> -->
					<tr>
						<td>Generate Htmls</td>
						<td><input width="100" type="button" name="generateHtmls"
							id="generateHtmls" value="Htmls"
							onclick="submitForm('generateHtmls')" /></td>
					</tr>
					<tr>
						<td>Generate Sitemaps</td>
						<td><input width="100" type="button" name="generateSitemap"
							id="generateSitemap" value="Sitemaps"
							onclick="submitForm('generateSitemap')" /></td>
					</tr>
				</table>
				<div id="pollResponseDiv"
					style="margin: 2px; height: 150px; border: 1px solid black; overflow: scroll;">
					<%=request.getAttribute("pollResponse")%>
				</div>
			</div>
			<div id="tabs-4">
				<table align="center" width="100%" border="0" cellpadding="2"
					cellspacing="2" class="ui-widget ui-widget-content ui-corner-all">
					<%
						Map hPropMap = ProductService.getPropertyMap();
					%>
					<%
						Iterator hPropMapItr = hPropMap.keySet().iterator();
					%>
					<tr>
						<td>View Configuration for :</td>
						<td><select id="property1" name="property1"
							onchange="showProduct();">
								<option value="">All Properties</option>
								<%
									while (hPropMapItr.hasNext()) {
								%>
								<%
									String propFile = (String) hPropMapItr.next();
										String propName = propFile.replaceAll("[/]", "");
								%>
								<option value="<%=propFile%>"><%=propName%></option>
								<%
									}
								%>
						</select></td>
					</tr>
				</table>
				<div style="margin: 2px; border: 1px solid black; overflow: scroll;">
					<%
						Map hPropMap1 = ProductService.getPropertyMap();
					%>
					<%
						Iterator hPropMapItr1 = hPropMap.keySet().iterator();
					%>
					<table width="100%" border="0" cellpadding="2" cellspacing="2"
						class="ui-widget ui-widget-content ui-corner-all">
						<tr>
							<td align="left" width="100%">&nbsp;</td>
						</tr>
						<%
							while (hPropMapItr1.hasNext()) {
						%>
						<%
							String propFile1 = (String) hPropMapItr1.next();
								String propName = propFile1.replaceAll("[/]", "");
						%>
						<tr id="row1_<%=propFile1%>">
							<td align="left" width="100%"><span style="font-size: 12px"><font
									color="Maroon"><H4><%=propName%></H4></font></span></td>
						</tr>
						<tr id="row2_<%=propFile1%>">
							<td width="100%">
								<table cellpadding="2" cellspacing="2"
									class="ui-widget ui-widget-content ui-corner-all"
									style="table-layout: fixed; width: 100%">
									<tr class="ui-widget ui-widget-header ui-corner-all">
										<td width="20%"
											style="word-wrap: break-word; word-break: break-all">
											Property Name</td>
										<td width="80%"
											style="word-wrap: break-word; word-break: break-all">
											Value</td>
									</tr>
									<%
										Properties prop = (Properties) hPropMap1.get(propFile1);
									%>
									<%
										Iterator propItr = prop.keySet().iterator();
									%>
									<%
										while (propItr.hasNext()) {
									%>
									<%
										String propKey = (String) propItr.next();
									%>
									<tr style="background-color: #eee">
										<td width="20%"
											style="word-wrap: break-word; word-break: break-all"><%=propKey%></td>
										<td width="80%"
											style="word-wrap: break-word; word-break: break-all"><%=prop.getProperty(propKey)%></td>
									</tr>
									<%
										}
									%>
								</table>
							</td>
						</tr>
						<%
							}
						%>
					</table>
				</div>
			</div>
			<div id="tabs-5">
				<table align="center" width="100%" border="0" cellpadding="2"
					cellspacing="2" class="ui-widget ui-widget-content ui-corner-all">

					<tr>
						<td>View Custom Sitemap file for ProductID:<select id="productIdForCustomSitemap"
							name="productIdForCustomSitemap">
								<%
									for (String s : ProductService.getProductIds()) {
								%>
								<option value="<%=s%>"><%=s%></option>
								<%
									}
								%>
						</select>
						</td>
						<td><input width="100" type="button" name="viewCustomSitemap" id="viewCustomSitemap" value="View Custom Sitemap" onclick="viewCustomSiteMapLink()" /></td>
					</tr>
				</table>
				<div id="CustomSitemapDiv"
					style="margin: 2px; height: 150px; border: 1px solid black; overflow: scroll;  padding-top: 30px;">
					<table id="CustomSitemapTable" align="center" border=1px></table><br>
					<center><input width="100" type="button" name="addSitemap" id="addSitemap" value="Add" style="display: none" onclick="addSitemapFunc()" /></center><br>
						<center><div id="addDiv" style="display: none">
							Location:<input type="text" id="addLoc"><br><br>
							Last Modified:<input type="text" id="addLastMod"><br><br>
							Change Frequency:<input type="text" id="addCF"><br><br>
							Priority:<input type="text" id="addPriority" required><br><br>
							<input width="100" type="button" name="submitSitemap" id="submitSitemap" value="Submit" onclick="submitSitemapFunc()" />
						</div></center>
				</div>
			</div>
		</div>
	</form>

</body>
</html>