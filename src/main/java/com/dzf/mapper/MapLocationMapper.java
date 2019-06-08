package com.dzf.mapper;

import com.dzf.pojo.Location;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MapLocationMapper {
    void storeLocation(Location location);

    List<Location> showOtherLocations(@Param("id") Integer id);

    void storelocationinrange(Location location);

    Integer deletelocations();
}
