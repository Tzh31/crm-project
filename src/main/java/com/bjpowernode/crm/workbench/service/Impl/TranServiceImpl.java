package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.mapper.DicValueMapper;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.FunnelVo;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.mapper.TranHistoryMapper;
import com.bjpowernode.crm.workbench.mapper.TranMapper;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

@Service
public class TranServiceImpl implements TranService {
    @Autowired
    TranMapper tranMapper;
    @Autowired
    CustomerMapper customerMapper;
    @Autowired
    TranHistoryMapper tranHistoryMapper;
@Autowired
    DicValueMapper dicValueMapper;

    @Override
    public List<Tran> queryTranByConditionForPage(Map<String, Object> map) {
        return tranMapper.selectTranByConditionForPage(map);
    }

    @Override
    public int queryTranCountByCondition(Map<String, Object> map) {
        return tranMapper.selectTranCountByCondition(map);
    }

    @Override
    public void saveCreateTran(Map<String, Object> map) {
        User user = (User) map.get("user");
        Customer customer = customerMapper.selectCustomerByName((String) map.get("customerName"));
        if (customer == null) {
            customer = new Customer();
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formateDateTime(new Date()));
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName((String) map.get("customerName"));
            int i = customerMapper.insertCustomer(customer);

        }
        Tran tran = new Tran();
        tran.setActivityId((String) map.get("activityId"));
        tran.setOwner((String) map.get("owner"));
        tran.setId(UUIDUtils.getUUID());
        tran.setMoney((String) map.get("money"));
        tran.setName((String) map.get("name"));
        tran.setExpectedDate((String) map.get("expectedDate"));
        tran.setCustomerId(customer.getId());
        tran.setStage((String) map.get("stage"));
        tran.setType((String) map.get("type"));
        tran.setSource((String) map.get("source"));
        tran.setActivityId((String) map.get("activityId"));
        tran.setContactsId((String) map.get("contactsId"));
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateUtils.formateDateTime(new Date()));
        tran.setDescription((String) map.get("description"));
        tran.setContactSummary((String) map.get("contactSummary"));
        tran.setNextContactTime((String) map.get("nextContactTime"));
        int i = tranMapper.insertTran(tran);
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranHistory.setTranId(tran.getId());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setStage(tran.getStage());
        tranHistoryMapper.insertNewTranHistory(tranHistory);

    }

    @Override
    public Tran queryTranForDetailByTranId(String tranId) {

        return tranMapper.selectTranForDetailByTranId(tranId);
    }

    @Override
    public List<FunnelVo> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }

    @Override
    public Tran queryTranForDetail(String id) {
        return tranMapper.selectTranForDetail(id);
    }

    @Override
    public Tran editTranStage(Map<String, Object> map) {
        DicValue s = dicValueMapper.selectDicValueIdByOrderNoAndTypeCode(String.valueOf(map.get("orderNo")));
        //这是点击得要切换的阶段id
        Tran tran = new Tran();
        tran.setOrderNo(s.getOrderNo());
        tran.setStage(s.getId());
        ResourceBundle resourceBundle=ResourceBundle.getBundle("db");
        String string = resourceBundle.getString(s.getValue());

        tran.setPossibility(string);

        User user= (User) map.get("user");
        tran.setEditBy(user.getId());
        tran.setEditTime(DateUtils.formateDateTime(new Date()));
tran.setId((String) map.get("tranId"));
tranMapper.updateStageByPrimaryKey(tran);

        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtils.getUUID());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranHistory.setTranId(tran.getId());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setStage(tran.getStage());
        tranHistoryMapper.insertNewTranHistory(tranHistory);
        return tran;

    }


}
