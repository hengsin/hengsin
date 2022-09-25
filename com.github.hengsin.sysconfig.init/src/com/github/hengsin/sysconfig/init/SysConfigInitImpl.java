/***********************************************************************
 * This file is part of iDempiere ERP Open Source                      *
 * http://www.idempiere.org                                            *
 *                                                                     *
 * Copyright (C) Contributors                                          *
 *                                                                     *
 * This program is free software; you can redistribute it and/or       *
 * modify it under the terms of the GNU General Public License         *
 * as published by the Free Software Foundation; either version 2      *
 * of the License, or (at your option) any later version.              *
 *                                                                     *
 * This program is distributed in the hope that it will be useful,     *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of      *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the        *
 * GNU General Public License for more details.                        *
 *                                                                     *
 * You should have received a copy of the GNU General Public License   *
 * along with this program; if not, write to the Free Software         *
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,          *
 * MA 02110-1301, USA.                                                 *
 *                                                                     *
 * Contributors:                                                       *
 * - hengsin                         								   *
 **********************************************************************/
package com.github.hengsin.sysconfig.init;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;

import org.compiere.Adempiere;
import org.compiere.model.MSysConfig;
import org.compiere.model.ServerStateChangeEvent;
import org.compiere.util.CacheMgt;
import org.compiere.util.DB;
import org.compiere.util.Ini;
import org.compiere.util.Util;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;

@Component(immediate = true, service = ISysConfigInit.class)
public class SysConfigInitImpl implements ISysConfigInit {

	private final static String PROPERTIES_FILE_NAME = "sysconfig.properties";
	
	public SysConfigInitImpl() {
	}

	@Activate
	void activate(Map<String, Object> properties) {
		if (Adempiere.isStarted()) {
			initFromProperties();
		} else {
			Adempiere.addServerStateChangeListener(e -> {
				if (e.getEventType() == ServerStateChangeEvent.SERVER_START) {
					initFromProperties();
				}
			});
		}
	}
	
	@Override
	/**
	 * Update AD_SysConfig with values from IDEMPIERE_HOME/sysconfig.properties
	 */
	public void initFromProperties() {
		String fileName = getPropertiesFile();
		Path path = Paths.get(fileName);
		if (Files.isReadable(path)) {						
			try {
				//check last modified
				String lastModified = Files.getLastModifiedTime(path).toString();
				String storedLastModified = null;
				Path lastModifiedPath = Paths.get(getLastModifiedFile());
				if (Files.isReadable(lastModifiedPath)) {
					storedLastModified = Files.readString(lastModifiedPath);
					if (storedLastModified != null)
						storedLastModified = storedLastModified.trim();
					if (Objects.equals(lastModified, storedLastModified))
						return;
				}
				if (!Files.isReadable(lastModifiedPath)) {
					lastModifiedPath = Files.createFile(lastModifiedPath);
				}
				try (FileWriter writer = new FileWriter(lastModifiedPath.toFile(), false)) {					
					if (storedLastModified != null && storedLastModified.length() > lastModified.length()) {
						writer.write((lastModified + " ".repeat(storedLastModified.length()-lastModified.length())));
					} else {
						writer.write(lastModified);
					}
				}
				
				//load properties
				Properties properties = new Properties();
				properties.load(new FileReader(path.toFile()));
				System.out.println("Copying " + fileName + " to AD_SysConfig");
				updateSysConfigWithProperties(properties);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	private void updateSysConfigWithProperties(Properties properties) {
		String sql = "SELECT AD_SysConfig_ID, Value FROM AD_SysConfig WHERE Name=? AND AD_Client_ID=0 AND IsActive='Y'";
		
		int changes = 0;
		for(String key : properties.stringPropertyNames()) {
			String value = properties.getProperty(key);
			if (!Util.isEmpty(value)) {
				try (PreparedStatement stmt = DB.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE, null)) {
					stmt.setString(1, key);
					ResultSet rs = stmt.executeQuery();
					if (rs.next()) {
						String rsv = rs.getString("Value");
						if (!Objects.equals(value, rsv)) {
							rs.updateString("Value", value);
							rs.updateRow();
							changes++;
						}
					}
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		if (changes > 0) {
			CacheMgt.get().reset(MSysConfig.Table_Name);
		}
	}

	private String getPropertiesFile ()
	{
		String base = Ini.getAdempiereHome();
		
		if (base != null && !base.endsWith(File.separator)) {
			base += File.separator;
		}
		
		//
		return base + PROPERTIES_FILE_NAME;
	}
	
	private String getLastModifiedFile ()
	{
		String base = Ini.getAdempiereHome();
		
		if (base != null && !base.endsWith(File.separator)) {
			base += File.separator;
		}
		
		//
		return base + PROPERTIES_FILE_NAME + ".lastmodified";
	}
}
