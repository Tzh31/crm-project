package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.commons.contans.Contans;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.bjpowernode.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.swing.text.Utilities;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    ClueMapper clueMapper;
    @Autowired
    CustomerMapper customerMapper;
    @Autowired
    ContactsMapper contactsMapper;
    @Autowired
    ClueRemarkMapper clueRemarkMapper;
    @Autowired
    CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    ContactsActivityRelationMapper contactsActivityRelationMapper;
@Autowired
TranMapper tranMapper;
@Autowired
    TranRemarkMapper tranRemarkMapper;
@Autowired
TranHistoryMapper tranHistoryMapper;
    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionForPage(map);
    }

    @Override
    public int queryCountClue(Map<String, Object> map) {
        return clueMapper.queryCountClue(map);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }


    @Override
    public void saveConvertClue(Map<String, Object> map) {
        String clueId = (String) map.get("clueId");
        User user = (User) map.get(Contans.SESSION_USER);
        Clue clue = clueMapper.selectDetailClueById(clueId);
        //把该线索下的有关公司的信息转换到客户表中
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setAddress(clue.getAddress());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setContactSummary(clue.getContactSummary());
        customer.setCreateBy(user.getId());
        customer.setDescription(clue.getDescription());
        int i = customerMapper.insertCustomer(customer);
        //把该线索下的有关个人的信息转换到联系人表中
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(user.getId());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formateDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        int i1 = contactsMapper.insertContacts(contacts);
//根据clueId查询该线索下的所有备注,并不带有其他表的外键

        List<ClueRemark> clueRemarks = clueRemarkMapper.selectDetailClueRemarkByClueId(clueId);
        if (clueRemarks != null && clueRemarks.size() > 0) {

            CustomerRemark customerRemark = null;
            ContactsRemark contactsRemark = null;
            List<CustomerRemark> customerRemarks = new ArrayList<>();
            List<ContactsRemark> contactsRemarks = new ArrayList<>();
            for (ClueRemark remark : clueRemarks
            ) {
                //给客户的备注赋值
                customerRemark = new CustomerRemark();

                customerRemark.setId(UUIDUtils.getUUID());
//          customerRemark.setCustomerId();
                customerRemark.setNoteContent(remark.getNoteContent());
                customerRemark.setCreateBy(remark.getCreateBy());
                customerRemark.setCreateTime(remark.getCreateTime());
                customerRemark.setEditBy(remark.getEditBy());
                customerRemark.setEditTime(remark.getEditTime());
                customerRemark.setEditFlag(remark.getEditFlag());
                customerRemark.setCustomerId(customer.getId());
//为联系人的备注赋值
                contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtils.getUUID());
//          contactsRemark.setCustomerId();
                contactsRemark.setNoteContent(remark.getNoteContent());
                contactsRemark.setCreateBy(remark.getCreateBy());
                contactsRemark.setCreateTime(remark.getCreateTime());
                contactsRemark.setEditBy(remark.getEditBy());
                contactsRemark.setEditTime(remark.getEditTime());
                contactsRemark.setEditFlag(remark.getEditFlag());
contactsRemark.setContactsId(contacts.getId());
                contactsRemarks.add(contactsRemark);
                customerRemarks.add(customerRemark);
            }
            //往客户备注的标注里插入所有备注
            int i2 = customerRemarkMapper.insertRemark(customerRemarks);

            int i3 = contactsRemarkMapper.insertContactsRemark(contactsRemarks);
        }
        List<ClueActivityRelation> clueActivityRelations = clueActivityRelationMapper.selectClueActivityRelation(clueId);
        ContactsActivityRelation contactsActivityRelation = null;
        List<ContactsActivityRelation> contactsActivityRelations = new ArrayList<>();
        if (clueActivityRelations != null && clueActivityRelations.size() > 0) {

            for (ClueActivityRelation clueActivityRelation : clueActivityRelations
            ) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelations.add(contactsActivityRelation);
            }
            //联系人和市场活动的关联关系表
            int i2 = contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelations);

        }

        if ("true".equals(map.get("isTransfer"))) {
            Tran tran = new Tran();
            tran.setId(UUIDUtils.getUUID());
            tran.setMoney((String) map.get("money"));
            tran.setName((String) map.get("name"));
            tran.setExpectedDate((String) map.get("expectedDate"));
            tran.setSource((String) map.get("source"));
            tran.setStage((String) map.get("stage"));
            tran.setCustomerId(customer.getId());
            tran.setOwner(user.getId());
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formateDateTime(new Date()));
            tran.setActivityId((String) map.get("activityId"));
            int i2 = tranMapper.insertTran(tran);
            TranRemark tranRemark=null;
            List<TranRemark>list=new ArrayList<>();
            if (clueRemarks != null && clueRemarks.size() > 0) {
                for (ClueRemark remark : clueRemarks
                ) {
                    //给客户的备注赋值
                    tranRemark = new TranRemark();

                    tranRemark.setId(UUIDUtils.getUUID());
//          custtranRemarkCustomerId();
                    tranRemark.setNoteContent(remark.getNoteContent());
                    tranRemark.setCreateBy(remark.getCreateBy());
                    tranRemark.setCreateTime(remark.getCreateTime());
                    tranRemark.setEditBy(remark.getEditBy());
                    tranRemark.setEditTime(remark.getEditTime());
                    tranRemark.setEditFlag(remark.getEditFlag());
                    tranRemark.setTranId(tran.getId());
                    list.add(tranRemark);
                }
                tranRemarkMapper.insertTranRemark(list);

            }
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
        int i2 = clueRemarkMapper.deleteClueRemarkByRemarkId(clueId);
        int i3 = clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
        int i4 = clueMapper.deleteClueById(clueId);

    }

    @Override
    public int deleteClueByClueId(String[] id) {
        return clueMapper.deleteClueByClueId(id);
    }
}
