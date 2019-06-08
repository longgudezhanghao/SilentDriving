package com.dzf.service;

import com.dzf.pojo.Location;

import java.util.List;

public interface MapLocationservice {

    void storeLocation(Location location);

    List<Location> showOtherLocations(Integer id);

    void storelocationinrange(Location location);

    Integer deletelocations();
}
