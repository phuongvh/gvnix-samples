// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.springsource.petclinic.web;

import com.springsource.petclinic.domain.Owner;
import com.springsource.petclinic.domain.Pet;
import com.springsource.petclinic.domain.Vet;
import com.springsource.petclinic.web.OwnerController;
import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.joda.time.format.DateTimeFormat;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect OwnerController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String OwnerController.create(@Valid Owner owner, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, owner);
            return "owners/create";
        }
        uiModel.asMap().clear();
        owner.persist();
        return "redirect:/owners/" + encodeUrlPathSegment(owner.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String OwnerController.createForm(Model uiModel) {
        populateEditForm(uiModel, new Owner());
        return "owners/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String OwnerController.show(@PathVariable("id") Long id, Model uiModel) {
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("owner", Owner.findOwner(id));
        uiModel.addAttribute("itemId", id);
        return "owners/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String OwnerController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("owners", Owner.findOwnerEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) Owner.countOwners() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("owners", Owner.findAllOwners(sortFieldName, sortOrder));
        }
        addDateTimeFormatPatterns(uiModel);
        return "owners/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String OwnerController.update(@Valid Owner owner, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, owner);
            return "owners/update";
        }
        uiModel.asMap().clear();
        owner.merge();
        return "redirect:/owners/" + encodeUrlPathSegment(owner.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String OwnerController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, Owner.findOwner(id));
        return "owners/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String OwnerController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Owner owner = Owner.findOwner(id);
        owner.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/owners";
    }
    
    void OwnerController.addDateTimeFormatPatterns(Model uiModel) {
        uiModel.addAttribute("owner_birthday_date_format", DateTimeFormat.patternForStyle("M-", LocaleContextHolder.getLocale()));
    }
    
    void OwnerController.populateEditForm(Model uiModel, Owner owner) {
        uiModel.addAttribute("owner", owner);
        addDateTimeFormatPatterns(uiModel);
        uiModel.addAttribute("pets", Pet.findAllPets());
        uiModel.addAttribute("vets", Vet.findAllVets());
    }
    
    String OwnerController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}