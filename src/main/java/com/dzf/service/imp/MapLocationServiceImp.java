package com.dzf.service.imp;

import com.dzf.mapper.MapLocationMapper;
import com.dzf.pojo.Location;
import com.dzf.service.MapLocationservice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("mapService")
public class MapLocationServiceImp implements MapLocationservice {

    @Autowired
    private MapLocationMapper mapLocationMapper;

    @Override
    public void storeLocation(Location location) {

        mapLocationMapper.storeLocation(location);

    }

    @Override
    public List<Location> showOtherLocations(Integer id) {

        return mapLocationMapper.showOtherLocations(id);
    }

    @Override
    public void storelocationinrange(Location location) {

        mapLocationMapper.storelocationinrange(location);
    }

    @Override
    public Integer deletelocations() {

        return mapLocationMapper.deletelocations();
    }
}
